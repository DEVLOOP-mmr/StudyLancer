import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test to fetch chat rooms', () async {
    /// TODO: inject mock firebase
    final bloc = FirebaseChatBloc();
    Student student = Student(optionStatus: 1)
      ..id = MockFirebaseStudentUser().uid;
    bloc.fetchRooms(student);
    await Future.doWhile(() {
      if (bloc.state.loadState == LoadState.loading) {
        return true;
      }
      return false;
    });
    if (bloc.state.rooms?.isNotEmpty ?? false) {
      expect(bloc.state.rooms!.first.users.first!.id, student.id);
    }
  }, skip: true);
}
