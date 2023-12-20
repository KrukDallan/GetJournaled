import 'dart:async';

import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:getjournaled/hive_notes.dart';

class LocalNoteMapService extends NoteMapsService {
  Map<int, Map<String, dynamic>> _cacheMap = {};
  late Box _boxSingleNotes;

  void loadCacheMap() {
    if (_boxSingleNotes.length > 0) {
      for (int i = 0; i < _boxSingleNotes.length; i++) {
        HiveNotes hn = _boxSingleNotes.getAt(i);
        Map<String, dynamic> tmp = {hn.title: hn.body};
        _cacheMap.putIfAbsent(hn.id, () => tmp);
      }
    }
  }

  Future<bool> isEmpty() async {
    return _cacheMap.isEmpty;
  }

  Future<int> getLastId() async{
    return _cacheMap.keys.last;
  }

  @override
  Future<void> add(int id, Map<String, dynamic> map) async {
    Map<int, Map<String, dynamic>> tmp = {id: map};
    streamNoteController.add(tmp);
    _cacheMap.putIfAbsent(id, () => map);
    HiveNotes hv =
        HiveNotes(title: map.keys.first, body: map.values.firstOrNull, id: id);
    _boxSingleNotes.put(id, hv);
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
  Future<void> open() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveNotesAdapter());
    _boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes1');
    loadCacheMap();
  }

  @override
  Future<bool> remove(int id) async {
    if (_cacheMap.containsKey(id)) {
      _cacheMap.remove(id);
      _boxSingleNotes.deleteAt(id);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Map<int, Map<String, dynamic>>> getAllNotes() async {
    return _cacheMap;
  }

  @override
  Future<void> update(int id, Map<String, dynamic> map) async{
    _cacheMap[id] = map;
    Map<int, Map<String, dynamic>> tmp = {id: map};
    streamNoteController.add(tmp);
    HiveNotes hv =
        HiveNotes(title: map.keys.first, body: map.values.firstOrNull, id: id);
    _boxSingleNotes.putAt(id, hv);

  }
}
