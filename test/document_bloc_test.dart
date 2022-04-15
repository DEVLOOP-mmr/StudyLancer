

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/test_config/mocks/document_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'profile/profile_test.dart';
import 'utils/setups.dart';

void main() {
  setUp(() async {
    await TestSetups().setupHive();
  });
  group(
    'Document Operations:',
    () {
      test(
        'Document Upload Student',
        () async {
          final mockDocument = MockDocument();
          final response = await DocumentBloc.postDocument(
            mockDocument,
            MockFirebaseStudentUser().uid,
            overrideUserType: 'student',
          );

          expect(response.statusCode, 200);
          final student = await ProfileTestSuite().getStudentProfile();
          assert(student.id.isNotEmpty);
          expect(
            student.documents
                .any((element) => element.name == mockDocument.name),
            true,
          );
        },
      );
      test(
        'Document Upload Agent',
        () async {
          final mockDocument = MockDocument();
          final response = await DocumentBloc.postDocument(
            mockDocument,
            MockFirebaseStudentUser().uid,
            overrideUserType: 'agent',
          );

          expect(response.statusCode, 200);
          final agent = await ProfileTestSuite().getAgentProfile();
          assert(agent.id.isNotEmpty);
          expect(
            agent.documents
                .any((element) => element.name == mockDocument.name),
            true,
          );
        },
      );
      test('Document Fetch', () async {
        final student = await ProfileTestSuite().getStudentProfile();
        assert(student.id.isNotEmpty);

        expect(student.documents, isNotEmpty);
        expect(student.documents.first.id, isNotEmpty);
      });
      test(
        'Document Delete Student',
        () async {
          var student = await ProfileTestSuite().getStudentProfile();
          assert(student.id.isNotEmpty);
          final lastDocID = student.documents.last.id;
          final response = await DocumentBloc.deleteDocument(
            student.documents.last.name,
            lastDocID,
            MockFirebaseStudentUser().uid,
          );
          expect(response.statusCode, 200);
          var deletedDocumentStudent =
              await ProfileTestSuite().getStudentProfile();
          expect(
            deletedDocumentStudent.documents
                .any((element) => element.id == lastDocID),
            false,
          );
        },
      );
       test(
        'Document Delete Agent',
        () async {
          var agent = await ProfileTestSuite().getAgentProfile();
          assert(agent.id.isNotEmpty);
          final lastDocID = agent.documents.last.id;
          final response = await DocumentBloc.deleteDocument(
            agent.documents.last.name,
            lastDocID,
            MockFirebaseStudentUser().uid,
          );
          expect(response.statusCode, 200);
          var deletedDocumentAgent =
              await ProfileTestSuite().getAgentProfile();
          expect(
            deletedDocumentAgent.documents
                .any((element) => element.id == lastDocID),
            false,
          );
        },
      );
    },
  );
}
