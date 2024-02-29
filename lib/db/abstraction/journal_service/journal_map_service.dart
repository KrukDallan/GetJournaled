import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/journals/journal_object.dart';

abstract class JournalService{
  @protected
final StreamController<Map<int,JournalObject>> streamJournalController = StreamController.broadcast();

Stream<Map<int, JournalObject>> get stream => streamJournalController.stream;

Future<void> add(JournalObject journalObject);

Future<void> dispose() async {
 streamJournalController.close();
}

Future<JournalObject?> get(int id);

Future<Map<int,JournalObject>> getAllJournals();

int getUniqueId();

// Initialize the service
Future<void> open();

Future<bool> remove(int id);

Future<void> removeAll();

Future<bool> update(JournalObject journalObject);

}