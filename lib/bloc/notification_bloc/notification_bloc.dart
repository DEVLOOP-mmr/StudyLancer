import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:io';

import 'package:http/http.dart' as http;

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    FirebaseAuth.instance.authStateChanges().asBroadcastStream().listen((user) {
      if (user != null) {
        registerFCMToken();
        registerNotificationListener();
      }
    });
  }

  void registerNotificationListener() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    log(settings.authorizationStatus.toString());
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        EasyLoading.showToast(
          '${message.notification?.title}',
          duration: const Duration(
            seconds: 3,
          ),
        );
      }
    });
  }

  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  final fcmKey =
      "AAAAwWbX1sA:APA91bE11G6-1MGcArB5R0eZRzb-nlSSPdHfMn35VSAw_0LaTrhZaHrfE7Sbc7KeSy2KYrB9hGU3s1czLAqJBs_Ey8B8XRSwgEFEWRKUKMIvEtbh1wntPGeAQAZKGi_Ced_xK42fOvHT";

  void sendFcm(String title, String body, String fcmToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey'
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body =
        '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log('notification sent');
    } else {
      log('error');
    }
  }

  Future<bool> hasValidFCMToken() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('fcm')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot == null) {
      return false;
    }
    final data = snapshot.data();
    if (data == null) {
      return false;
    }
    try {
      final String token = data['token'];
      Timestamp timeGenerated = data['generated'];
      if (token.length > 3 &&
          DateTime.now().difference(timeGenerated.toDate()).inDays < 30) {
        emit(state.copyWith(currentToken: token));

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void registerFCMToken() async {
    if (!await hasValidFCMToken()) {
      final newToken = await FirebaseMessaging.instance.getToken();
      emit(state.copyWith(currentToken: newToken));
      await FirebaseFirestore.instance
          .collection('fcm')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'token': newToken,
        'generated': Timestamp.fromDate(DateTime.now()),
      });
      sendFcm('Welcome To Study Lancer!', '', newToken!);
    } else {
      sendFcm('Welcome To Study Lancer!', '', state.currentToken);
    }
  }
}

class NotificationInitial extends NotificationState {
  NotificationInitial() : super(currentToken: '');
}

class NotificationState {
  final String currentToken;
  NotificationState({
    required this.currentToken,
  });

  NotificationState copyWith({
    String? currentToken,
  }) {
    return NotificationState(
      currentToken: currentToken ?? this.currentToken,
    );
  }
}
