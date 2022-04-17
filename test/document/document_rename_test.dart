import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/test_config/mocks/document_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';
import '../utils/setups.dart';
void main(){
   group('Document Rename:', () {
    test(
      'student',
      () async {
        var student = await ProfileTestSuite().getStudentProfile();
        assert(student.id.isNotEmpty);
        var mockDocument = MockDocument();
        if (student.documents.isEmpty) {
          await DocumentBloc(userType: 'student').postDocument(
            mockDocument,
            MockFirebaseStudentUser().uid,
          );
          student = await ProfileTestSuite().getStudentProfile();
        }
        final lastDocID = student.documents.last.id;
        final response = await DocumentBloc(userType: 'student').updateDocument(
          student.documents.last.id,
          'test_name',
          MockFirebaseStudentUser().uid,
        );
        expect(response.statusCode, 200);
        var renamedDocumentStudent =
            await ProfileTestSuite().getStudentProfile();
        expect(
          renamedDocumentStudent.documents
              .any((element) => element.name == 'test_name'),
          true,
        );
      },
    );
    test(
      'agent',
      () async {
        var agent = await ProfileTestSuite().getAgentProfile();
        assert(agent.id.isNotEmpty);
        var mockDocument = MockDocument();
        if (agent.documents.isEmpty) {
          await DocumentBloc(userType: 'agent').postDocument(
            mockDocument,
            MockFirebaseStudentUser().uid,
          );
          agent = await ProfileTestSuite().getAgentProfile();
        }
        final lastDocID = agent.documents.last.id;
        final response = await DocumentBloc(userType: 'agent').updateDocument(
          agent.documents.last.id,
          'test_name',
          MockFirebaseStudentUser().uid,
        );
        expect(response.statusCode, 200);
        var agentDocumentStudent = await ProfileTestSuite().getStudentProfile();
        expect(
          agentDocumentStudent.documents
              .any((element) => element.name == 'test_name'),
          true,
        );
      },
    );
  });

}