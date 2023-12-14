import 'dart:async';

abstract class NoteMapsService{
final StreamController<Map<int,Map<String,dynamic>>> _streamNoteController = StreamController.broadcast();

Stream<Map<int, Map<String, dynamic>>> get stream => _streamNoteController.stream;

Future<void> add(int id, Map<String,dynamic> map);

Future<bool> remove(int id);

Future<Map<String,dynamic>> get(int id);

Future<Map<int, Map<String, dynamic>>> getAllNotes();

// Initialize the service
Future<void> open();

Future<void> dispose() async {
 _streamNoteController.close();
}

}