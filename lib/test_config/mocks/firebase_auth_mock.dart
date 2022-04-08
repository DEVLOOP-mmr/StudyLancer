import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User get currentUser => MockFirebaseUser();
}

class MockFirebaseUser extends Mock implements User {
  @override
  String get uid => "w1tQWOzFPtcM6rG68LJK66lrnNx1";


  @override
  String get phoneNumber => "+911111111111";
}
