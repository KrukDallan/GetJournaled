import 'dart:async';

import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/hive/hive_unique_id.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:getjournaled/hive/hive_notes.dart';
import 'package:getjournaled/notes/note_object_class.dart';

class LocalNoteMapService extends NoteService {
  Set<NoteObject> _cacheSet = {};
  Set<int> _ids = {};
  late Box _boxSingleNotes;
  late Box _boxUniqueId;
  late int _uniqueId;

  @override
  Future<void> add(NoteObject noteObject) async {
    print('ID IS: ${noteObject.getId()}');
    // check presence
    if (_ids.contains(noteObject.getId())) {
      update(noteObject);
    } else {
      _cacheSet.add(noteObject);
      _ids.add(noteObject.getId());
      streamNoteController.add(_cacheSet);

      // insert in hive box
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

    return Future(() => null);
  }

  @override
  Future<NoteObject?> get(int id) async {
    if (_ids.contains(id)) {
      return _cacheSet.firstWhere((element) => element.getId() == id);
    }
    return null;
  }

  @override
  Future<Set<NoteObject>> getAllNotes() async {
    return _cacheSet;
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
    _boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes5');
    _boxUniqueId = await Hive.openBox<HiveUniqueId>('UniqeId5');
    loadCacheSet();
    _uniqueId = loadUniqueId();
  }

  @override
  Future<bool> remove(int id) async {
  
    if (_ids.contains(id)) {
        print('ID to delete: $id');
      _cacheSet.removeWhere((element) => element.getId() == id);
      _boxSingleNotes.delete(id);
      _ids.remove(id);
      streamNoteController.add(_cacheSet);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> removeAll() {
    // doesn't work; 'concurrent modification during iteration'
    _cacheSet.clear();
    _boxSingleNotes.clear();
    _uniqueId = 0;
    _boxUniqueId.put(0, HiveUniqueId(id: 0));
    streamNoteController.add(_cacheSet);

    return Future(() => null);
  }

  @override
  Future<bool> update(NoteObject noteObject) async {
    // check presence
    if (_ids.contains(noteObject.getId())) {
      _cacheSet.removeWhere((element) => element.getId() == noteObject.getId());
      _cacheSet.add(noteObject);
      streamNoteController.add(_cacheSet);
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

  void loadCacheSet() {
    if (_boxSingleNotes.length > 0) {
      for (var k in _boxSingleNotes.keys) {
        HiveNotes hn = _boxSingleNotes.get(k);
        NoteObject noteObject = NoteObject(
            id: hn.id,
            title: hn.title,
            body: hn.body,
            dateOfCreation: hn.dateOfCreation,
            dateOfLastEdit: hn.dateOfLastEdit);
        _cacheSet.add(noteObject);
      }
    }
  }

  int loadUniqueId() {
    if (_boxUniqueId.length > 0) {
      HiveUniqueId tmp = _boxUniqueId.getAt(0);
      return tmp.id ;
    } else {
      return 0;
    }
  }
}
