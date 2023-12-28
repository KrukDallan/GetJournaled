import 'dart:async';

import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/hive/hive_unique_id.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:getjournaled/hive/hive_notes.dart';

class LocalNoteMapService extends NoteMapsService {
  final Map<int, Map<String, dynamic>> _cacheMap = {};
  late Box _boxSingleNotes;
  late Box _boxUniqueId;
  late int _uniqueId;

  @override
  Future<void> add(int id, Map<String, dynamic> map) async {
    print('ID IS: $id');
    // insert map in stream controller
    Map<int, Map<String, dynamic>> tmp = {_uniqueId: map};
    streamNoteController.add(tmp);

    // check presence
    // TODO: change how to manage this case
    if (_cacheMap.containsKey(id)) {
      _cacheMap[id] = map;
      print('KEY ALREADY PRESENT');
    } else {
      _cacheMap.putIfAbsent(id, () => map);
    }

    // insert in hive box
    HiveNotes hv = HiveNotes(
        title: map.keys.first,
        body: map.values.firstOrNull as String,
        id: _uniqueId,
        dateOfCreation: DateTime(0),
        dateOfLastEdit: DateTime(0),
        );
    _boxSingleNotes.put(_uniqueId, hv);

    // update the id
    _uniqueId += 1;

    // put the unique id always in the same position in the hive box
    HiveUniqueId hui = HiveUniqueId(id: _uniqueId);
    _boxUniqueId.put(0, hui);

    return Future(() => null);
  }

  @override
  Future<Map<String, dynamic>?> get(int id) async {
    if (_cacheMap.containsKey(id)) {
      return _cacheMap[id];
    }
    return null;
  }

  @override
  Future<Map<int, Map<String, dynamic>>> getAllNotes() async {
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
    _boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes4');
    _boxUniqueId = await Hive.openBox<HiveUniqueId>('UniqeId4');
    loadCacheMap();
    _uniqueId = loadUniqueId();
  }

  @override
  Future<bool> remove(int id) async {
    if (_cacheMap.containsKey(id)) {
      _cacheMap.remove(id);
      _boxSingleNotes.delete(id);
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

    return Future(() => null);
  }

  @override
  Future<void> update(int id, Map<String, dynamic> map) {
    // check presence
    if (_cacheMap.containsKey(id)) {
      _cacheMap[id] = map;
      streamNoteController.add(_cacheMap);
    }
    // insert in hive box
    HiveNotes hv = HiveNotes(
        title: map.keys.first,
        body: map.values.first as String,
        id: _uniqueId,
        dateOfCreation: DateTime(0),
        dateOfLastEdit: DateTime(0),
        );
    _boxSingleNotes.put(id, hv);
    return Future(() => null);
  }

  //
  // utility functions
  //        |0.................0.
  //        ∨

  void loadCacheMap() {
    if (_boxSingleNotes.length > 0) {
      for (var k in _boxSingleNotes.keys) {
        HiveNotes hn = _boxSingleNotes.get(k);
        Map<String, dynamic> tmp = {hn.title: hn.body};
        _cacheMap.putIfAbsent(hn.id, () => tmp);
      }
    }
  }

  int loadUniqueId() {
    if (_boxUniqueId.length > 0) {
      HiveUniqueId tmp = _boxUniqueId.getAt(0);
      return tmp.id + 1;
    } else {
      return 0;
    }
  }
}
