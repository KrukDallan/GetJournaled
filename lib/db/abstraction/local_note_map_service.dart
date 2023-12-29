import 'dart:async';


import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/hive/hive_unique_id.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:getjournaled/hive/hive_notes.dart';
import 'package:getjournaled/notes/note_object_class.dart';

class LocalNoteMapService extends NoteService {
  final Map<int, NoteObject> _cacheMap = {};
  late Box _boxSingleNotes;
  late Box _boxUniqueId;
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
  int getUniqueId() {
    return _uniqueId;
  }

  @override
  Future<void> open() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveNotesAdapter());
    Hive.registerAdapter(HiveUniqueIdAdapter());
    _boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes7');
    _boxUniqueId = await Hive.openBox<HiveUniqueId>('UniqeId7');
    loadCacheMap();
    _uniqueId = loadUniqueId();
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
      );
      _boxSingleNotes.put(noteObject.getId(), hv);
      return true;
    } else {
      add(noteObject);
      return false;
    }
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
            dateOfLastEdit: hn.dateOfLastEdit);
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
}
