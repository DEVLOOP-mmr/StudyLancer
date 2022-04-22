import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

class MockDocument extends Document {
  MockDocument()
      : super(
          link:
              'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          id: 'test_id_generated_' + Uuid().v4(),
          type: 'png',
          name: 'test_document_at_' + Uuid().v4(),
        );
}
