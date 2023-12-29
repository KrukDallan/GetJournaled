import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/notes/note_object_class.dart';

abstract class NoteService{
  @protected
final StreamController<Map<int,NoteObject>> streamNoteController = StreamController.broadcast();

Stream<Map<int, NoteObject>> get stream => streamNoteController.stream;

Future<void> add(NoteObject noteObject);

Future<void> dispose() async {
 streamNoteController.close();
}

Future<NoteObject?> get(int id);

Future<Map<int,NoteObject>> getAllNotes();

int getUniqueId();

// Initialize the service
Future<void> open();

Future<bool> remove(int id);

Future<void> removeAll();

Future<bool> update(NoteObject noteObject);

}