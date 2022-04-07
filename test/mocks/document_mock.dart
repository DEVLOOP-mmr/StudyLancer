import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:mockito/mockito.dart';

class MockDocument extends Mock implements Document {
  @override
  get link =>
      'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png';
  @override
  get id => 'test_id_generated_' + DateTime.now().toIso8601String();

  @override
  get type => 'png';
  
  @override
  get name => 'test_document_at_'+ DateTime.now().toIso8601String();
}
