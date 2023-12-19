
import 'dart:async';

import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:getjournaled/hive_notes.dart';
import 'package:getjournaled/boxes.dart';

class LocalNoteMapService extends NoteMapsService{

  Map<int,Map<String,dynamic>> cacheMap = {};

  void loadCacheMap(){
   if (boxSingleNotes.length > 0){
    for(int i = 0; i < boxSingleNotes.length; i++){
      HiveNotes hn = boxSingleNotes.getAt(i);
      Map<String,dynamic> tmp = {hn.title:hn.body};
      cacheMap[hn.id] = tmp;
    }
   } 
  }

  @override
  Future<void> add(int id, Map<String, dynamic> map) async {
    Map<int,Map<String,dynamic>> tmp = {id:map};
    streamNoteController.add(tmp);
    cacheMap[id] = map;
    HiveNotes hv = HiveNotes(title: map.keys.first, body: map.values.firstOrNull, id: id);
    boxSingleNotes.put(id, hv);
    return Future(() => null);
  }

  @override
  Future<Map<String, dynamic>?> get(int id) async {
    if(cacheMap.containsKey(id)){
      return cacheMap[id];
    }
    return null;
  }

  @override
  Future<void> open() async {
    await Hive.initFlutter();
   Hive.registerAdapter(HiveNotesAdapter());
   boxSingleNotes = await Hive.openBox<HiveNotes>('HiveNotes');
   loadCacheMap();
  }

  @override
  Future<bool> remove(int id) {
    // TODO: implement remove
    throw UnimplementedError();
  }


  @override
  Future<Map<int, Map<String, dynamic>>> getAllNotes() {
    // TODO: implement getAllNotes
    throw UnimplementedError();
  }

}