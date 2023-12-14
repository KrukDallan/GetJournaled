
import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:getjournaled/hive_notes.dart';
import 'package:getjournaled/boxes.dart';

class LocalNoteMapService implements NoteMapsService{

  // use hive

  @override
  Future<void> add(int id, Map<String, dynamic> map) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> open() async {
    await Hive.initFlutter();
   Hive.registerAdapter(HiveNotesAdapter());
   boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes');
  }

  @override
  Future<bool> remove(int id) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  // TODO: implement stream
  Stream<Map<int, Map<String, dynamic>>> get stream => throw UnimplementedError();
  
  @override
  Future<Map<int, Map<String, dynamic>>> getAllNotes() {
    // TODO: implement getAllNotes
    throw UnimplementedError();
  }

}