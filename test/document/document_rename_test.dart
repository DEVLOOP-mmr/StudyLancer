import 'package:elite_counsel/bloc/document_bloc/document_bloc.dart';
import 'package:elite_counsel/test_config/mocks/document_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';

void main() {
  group('Document Rename:', () {
    test(
      'student',
      () async {
        var student = (await (ProfileTestSuite().getStudentProfile()))!;
        assert(student.id!.isNotEmpty);
        var mockDocument = MockDocument();
        if (student.documents!.isEmpty) {
          await DocumentBloc(userType: 'student').postDocument(
            mockDocument,
            MockFirebaseStudentUser().uid,
          );
          student = (await (ProfileTestSuite().getStudentProfile()))!;
        }
        final lastDocID = student.documents!.last.id;
        final response = await DocumentBloc(userType: 'student').updateDocument(
          student.documents!.last.id,
          MockFirebaseStudentUser().uid,
          'test_name',
        );
        expect(response.statusCode, 200);
        var renamedDocumentStudent =
            (await (ProfileTestSuite().getStudentProfile()))!;
        expect(
          renamedDocumentStudent.documents!
              .any((element) => element.name == 'test_name'),
          true,
        );
      },
    );
    test(
      'agent',
      () async {
        var agent = (await (ProfileTestSuite().getAgentProfile()))!;
        assert(agent.id!.isNotEmpty);
        var mockDocument = MockDocument();
        if (agent.documents!.isEmpty) {
          await BlocProvider.of<DocumentBloc>(context, listen: false)
              .postDocument(
            mockDocument,
            MockFirebaseAgentUser().uid,
          );
          agent = (await (ProfileTestSuite().getAgentProfile()))!;
        }
        final lastDocID = agent.documents!.last.id;
        final response =
            await BlocProvider.of<DocumentBloc>(context, listen: false)
                .updateDocument(
          lastDocID,
          MockFirebaseAgentUser().uid,
          'test_name',
        );
        expect(response.statusCode, 200);
        agent = (await (ProfileTestSuite().getAgentProfile()))!;
        expect(
          agent.documents!.any((element) =>
              element.name == 'test_name' && element.id == lastDocID),
          true,
        );
      },
    );
  });
}
