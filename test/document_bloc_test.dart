import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/test_config/mocks/document_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'profile_test.dart';
import 'utils/setups.dart';

void main() {
  setUp(() async {
    await TestSetups().setupHive();
  });
  group(
    'Document Operations:',
    () {
      test('Document Fetch', () async {
        final student = await ProfileTestSuite().getStudentProfile();
        assert(student.id.isNotEmpty);

        expect(student.otherDoc, isNotEmpty);
        expect(student.otherDoc.first.id, isNotEmpty);
      });
      test(
        'Document Upload',
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
            student.otherDoc
                .any((element) => element.name == mockDocument.name),
            true,
          );
        },
      );

      test('Document Delete', () async {
        var student = await ProfileTestSuite().getStudentProfile();
        assert(student.id.isNotEmpty);
        final lastDocID = student.otherDoc.last.id;
        final response = await DocumentBloc.deleteDocument(
          lastDocID,
          MockFirebaseStudentUser().uid,
        );
        expect(response.statusCode, 200);
        var deletedDocumentStudent =
            await ProfileTestSuite().getStudentProfile();
        expect(
          deletedDocumentStudent.otherDoc
              .any((element) => element.id == lastDocID),
          false,
        );
      },
          skip:
              'Throws 404:https://winter-zodiac-822541.postman.co/workspace/a20aff49-dfa2-4898-8755-f562f4479020/request/14380364-be170c0a-7f79-47c7-9234-537796ccef5f');
    },
  );
}
