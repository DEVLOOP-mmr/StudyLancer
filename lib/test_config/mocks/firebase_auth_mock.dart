import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  String userType;
  MockFirebaseAuth(this.userType);

  set currentUser(_MockFirebaseUser user) {
    currentUser = user;
  }

  @override
  User get currentUser {
    final type = userType;
    if (type == null) {
      return MockFirebaseStudentUser();
    }
    if (type.toString().isEmpty) {
      return MockFirebaseStudentUser();
    }
    return type == 'student'
        ? MockFirebaseStudentUser()
        : MockFirebaseAgentUser();
  }
}

abstract class _MockFirebaseUser extends Mock implements User {
  String get otp;
}

class MockFirebaseStudentUser extends _MockFirebaseUser {
  @override
  String get uid => "w1tQWOzFPtcM6rG68LJK66lrnNx1";

  @override
  String get phoneNumber => "+911111111111";

  @override
  String otp = '111111';
}

class MockFirebaseAgentUser extends _MockFirebaseUser {
  @override
  String get uid => "IwhNBASOyJaXbgQLVMpLQOcM6m22";

  @override
  String get phoneNumber => "+919000000001";
  @override
  String otp = '111111';
}
