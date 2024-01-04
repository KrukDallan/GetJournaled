import 'dart:async';


import 'package:flutter/material.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/hive/hive_unique_id.dart';
import 'package:getjournaled/hive/notes/hive_tutorial_notes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:getjournaled/hive/notes/hive_notes.dart';
import 'package:getjournaled/notes/note_object.dart';

class LocalNoteMapService extends NoteService {
  final Map<int, NoteObject> _cacheMap = {};
  late Box _boxSingleNotes;
  late Box _boxUniqueId;
  late Box _boxTutorial;
  late int _uniqueId;

  @override
  Future<void> add(NoteObject noteObject) async {
    print('ID IS: ${noteObject.getId()}');

    // check presence
    if (_cacheMap.keys.contains(noteObject.getId())) {
      update(noteObject);
    } else {
      _cacheMap.addAll({noteObject.getId(): noteObject});
      streamNoteController.add(_cacheMap);
      HiveNotes hv = HiveNotes(
        title: noteObject.getTitle(),
        body: noteObject.getBody(),
        id: _uniqueId,
        dateOfCreation: noteObject.getDateOfCreation(),
        dateOfLastEdit: noteObject.getDateOfCreation(), 
        cardColorIntValue: noteObject.getCardColor().value,
      );
      _boxSingleNotes.put(_uniqueId, hv);
      // update the id
      _uniqueId += 1;

      // put the unique id always in the same position in the hive box
      HiveUniqueId hui = HiveUniqueId(id: _uniqueId);
      _boxUniqueId.put(0, hui);
    }

    print('uniqueid is: $_uniqueId');

    return Future(() => null);
  }

  @override
  Future<NoteObject?> get(int id) async {
    if (_cacheMap.keys.contains(id)) {
      return _cacheMap[id];
    }
    return null;
  }

  @override
  Future<Map<int, NoteObject>> getAllNotes() async {
    return _cacheMap;
  }

  @override
  bool getTutorialNotesValue() {
    HiveTutorialNotes htn = _boxTutorial.getAt(0);
    return htn.dismissed;
  }

  @override
  int getUniqueId() {
    return _uniqueId;
  }

  @override
  Future<void> open() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveNotesAdapter());
    Hive.registerAdapter(HiveUniqueIdAdapter());
    Hive.registerAdapter(HiveTutorialNotesAdapter());
    _boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes9');
    _boxUniqueId = await Hive.openBox<HiveUniqueId>('HiveNotesUniqeId9');
    _boxTutorial = await Hive.openBox<HiveTutorialNotes>('HiveTutorial9');
    loadCacheMap();
    _uniqueId = loadUniqueId();
    loadHiveTutorialBox();
  }

  @override
  Future<bool> remove(int id) async {
    print('ID to delete: $id');
    if (_cacheMap.keys.contains(id)) {
      print('deleting');
      _cacheMap.remove(id);
      _boxSingleNotes.delete(id);
      streamNoteController.add(_cacheMap);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> removeAll() {
    // doesn't work; 'concurrent modification during iteration'
    _cacheMap.clear();
    _boxSingleNotes.clear();
    _uniqueId = 0;
    _boxUniqueId.put(0, HiveUniqueId(id: 0));
    streamNoteController.add(_cacheMap);

    return Future(() => null);
  }

  @override
  Future<bool> update(NoteObject noteObject) async {
    // check presence
    if (_cacheMap.keys.contains(noteObject.getId())) {
      _cacheMap.addAll({noteObject.getId(): noteObject});
      streamNoteController.add(_cacheMap);
      // update in hive box
      HiveNotes hv = HiveNotes(
        title: noteObject.getTitle(),
        body: noteObject.getBody(),
        id: noteObject.getId(),
        dateOfCreation: noteObject.getDateOfCreation(),
        dateOfLastEdit: noteObject.getDateOfLastEdit(),
        cardColorIntValue: noteObject.getCardColor().value,
      );
      _boxSingleNotes.put(noteObject.getId(), hv);
      return true;
    } else {
      add(noteObject);
      return false;
    }
  }

  @override
  Future<void> updateHiveTutorial(HiveTutorialNotes htn) {
    _boxTutorial.putAt(0, htn);
    return Future(() => null);

  }

  //
  // utility functions
  //        |
  //        ∨

  void loadCacheMap() {
    if (_boxSingleNotes.length > 0) {
      for (var k in _boxSingleNotes.keys) {
        HiveNotes hn = _boxSingleNotes.get(k);
        NoteObject noteObject = NoteObject(
            id: hn.id,
            title: hn.title,
            body: hn.body,
            dateOfCreation: hn.dateOfCreation,
            dateOfLastEdit: hn.dateOfLastEdit, 
            cardColor: Color(hn.cardColorIntValue));
        _cacheMap.addAll({hn.id: noteObject});
      }
    }
  }

  int loadUniqueId() {
    if (_boxUniqueId.length > 0) {
      HiveUniqueId tmp = _boxUniqueId.getAt(0);
      return tmp.id;
    } else {
      return 0;
    }
  }

  void loadHiveTutorialBox() {
    if(_boxTutorial.length == 0) {
      HiveTutorialNotes htn = HiveTutorialNotes(dismissed: false);
      _boxTutorial.add(htn);
    }
  }
}
