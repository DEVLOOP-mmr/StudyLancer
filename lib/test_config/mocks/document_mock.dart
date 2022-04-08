import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:mockito/mockito.dart';

class MockDocument extends Document {
  MockDocument()
      : super(
          link:
              'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          id: 'test_id_generated_' + DateTime.now().toIso8601String(),
          type: 'png',
          name: 'test_document_at_' + DateTime.now().toIso8601String(),
        );
}
