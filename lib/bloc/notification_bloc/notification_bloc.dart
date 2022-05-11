import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite_counsel/bloc/notification_bloc/notification_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    FirebaseAuth.instance.authStateChanges().asBroadcastStream().listen((user) {
      if (user != null) {
        _registerNotificationListener().then((value) => _registerFCMToken());
      }
    });
  }
  static NotificationDetails _initLocalNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '0',
      'notifications',
      importance: Importance.high,
      icon: "app_icon",
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    return notificationDetails;
  }

  static void showLocalNotification(String title, String body) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final notifDetails = _initLocalNotification();
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notifDetails,
    );
  }

  Future<void> _registerNotificationListener() async {
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

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message?.notification != null) {
        showLocalNotification(
          message!.notification!.title!,
          message.notification!.body!,
        );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLocalNotification(
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });
  }

  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  static const fcmKey =
      "AAAAwWbX1sA:APA91bE11G6-1MGcArB5R0eZRzb-nlSSPdHfMn35VSAw_0LaTrhZaHrfE7Sbc7KeSy2KYrB9hGU3s1czLAqJBs_Ey8B8XRSwgEFEWRKUKMIvEtbh1wntPGeAQAZKGi_Ced_xK42fOvHT";

  static Future<void> _sendNotificationToFCMToken(
    String title,
    String body,
    String fcmToken,
  ) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey',
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body =
        '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('notification sent');
    } else {
      log('error');
    }
  }

  static void sendNotificationToUser(
    String title,
    String body,
    String uid,
  ) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('fcm').doc(uid).get();

    final data = snapshot.data();
    if (data == null) {
      print('user not registered');
      return;
    }

    final String token = data['token'];
    await _sendNotificationToFCMToken(title, body, token);
  }

  Future<bool> _hasValidFCMToken() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('fcm')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

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

  void _registerFCMToken() async {
    if (!await _hasValidFCMToken()) {
      final newToken = await FirebaseMessaging.instance.getToken();
      emit(state.copyWith(currentToken: newToken));
      await FirebaseFirestore.instance
          .collection('fcm')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'token': newToken,
        'generated': Timestamp.fromDate(DateTime.now()),
      });
      _sendNotificationToFCMToken('Welcome To Study Lancer!', '', newToken!);
    } else {
      _sendNotificationToFCMToken(
        'Welcome To Study Lancer!',
        '',
        state.currentToken,
      );
    }
  }
}
