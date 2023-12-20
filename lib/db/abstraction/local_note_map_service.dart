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
    for(var i in _cacheMap.values){
      print(i.keys.first);
    }
    Map<int, Map<String, dynamic>> tmp = {_uniqueId: map};
    streamNoteController.add(tmp);
    _cacheMap[_uniqueId] = map;
    HiveNotes hv =
        HiveNotes(title: map.keys.first, body: map.values.firstOrNull as String, id: _uniqueId);
    _boxSingleNotes.add(hv);
    _uniqueId +=1;
        for(var i in _cacheMap.values){
      print(i.keys.first);
    }
    _boxUniqueId.putAt(0, _uniqueId+1);
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
    _boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes1');
    _boxUniqueId = await Hive.openBox<HiveUniqueId>('UniqeId');
    loadCacheMap();
    _uniqueId = loadUniqueId();
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
  Future<void> update(int id, Map<String, dynamic> map) async{
    _cacheMap[id] = map;
    Map<int, Map<String, dynamic>> tmp = {id: map};
    streamNoteController.add(tmp);
    HiveNotes hv =
        HiveNotes(title: map.keys.first, body: map.values.firstOrNull, id: id);
    _boxSingleNotes.putAt(id, hv);
  }

  // utility functions
  //        |
  //        ∨

  void loadCacheMap() {
    if (_boxSingleNotes.length > 0) {
      for (int i = 0; i < _boxSingleNotes.length; i++) {
        HiveNotes hn = _boxSingleNotes.getAt(i);
        Map<String, dynamic> tmp = {hn.title: hn.body};
        _cacheMap.putIfAbsent(hn.id, () => tmp);
        //print('Id: ${hn.id}, ${hn.title}');
      }
      for(var j in _boxSingleNotes.keys){
        //print('box key: ${j}');
      }
    }
  }

  int loadUniqueId() {
    if(_boxUniqueId.length > 0){
      HiveUniqueId tmp = _boxUniqueId.getAt(0);
      return tmp.id;
    }
    else{
      return 0;
    }
  }
}
