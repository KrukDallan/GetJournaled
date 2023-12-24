import 'dart:async';

import 'package:flutter/material.dart';

abstract class NoteMapsService{
  @protected
final StreamController<Map<int,Map<String,dynamic>>> streamNoteController = StreamController.broadcast();

Stream<Map<int, Map<String, dynamic>>> get stream => streamNoteController.stream;

Future<void> add(int id, Map<String,dynamic> map);

Future<void> dispose() async {
 streamNoteController.close();
}

Future<Map<String,dynamic>?> get(int id);

Future<Map<int, Map<String, dynamic>>> getAllNotes();

int getUniqueId();

// Initialize the service
Future<void> open();

Future<bool> remove(int id);

Future<void> removeAll();

Future<void> update(int id,  Map<String,dynamic> map);

}