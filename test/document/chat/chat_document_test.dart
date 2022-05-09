import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  String testChatID = "123443";

  test('Test to get all chat documents', () async {
    List<Document>? docs =
        await DocumentBloc(userType: 'student').getChatDocs(testChatID);
    expect(docs, isNotNull);
    expect(docs, isNotEmpty);
    expect(docs?.first.link, isNotEmpty);
  });

  test('Test to add a document to chat', () async {
    var docName = 'chat_doc_' + const Uuid().v4();
    await DocumentBloc(userType: 'student').postChatDocument(
      Document(
        link: 'www.google.com',
        type: '.jpg',
        name: docName,
      ),
      testChatID,
    );
    List<Document>? docs =
        await DocumentBloc(userType: 'student').getChatDocs(testChatID);
    expect(docs?.any((element) => element.name == docName), true);
  });
}
