import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/db/abstraction/journal_service/journal_map_service.dart';
import 'package:getjournaled/hive/hive_journal.dart';
import 'package:getjournaled/hive/hive_unique_id.dart';
import 'package:getjournaled/journals/journal_object.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalJournalMapService extends JournalService {
  final Map<int, JournalObject> _cacheMap = {};
  late Box _boxSingleJournal;
  late Box _boxUniqueId;
  late int _uniqueId;

  @override
  Future<void> add(JournalObject journalObject) async {

    if(_cacheMap.keys.contains(journalObject.getId())){
      update(journalObject);
    }
    else{
      _cacheMap.addAll({journalObject.getId() : journalObject});
      streamJournalController.add(_cacheMap);
      HiveJournal hj = HiveJournal(
        id: journalObject.getId(), 
        body: journalObject.getBody(), 
        dateOfCreation: journalObject.getDateOfCreation(), 
        cardColorIntValue: journalObject.getCardColor().value
        );
        _boxSingleJournal.put(_uniqueId, hj);
        _uniqueId += 1;

        HiveUniqueId hui = HiveUniqueId(id: _uniqueId);
        _boxUniqueId.put(0, hui);
    }
    return Future(() => null);
  }

  @override
  Future<JournalObject?> get(int id) async {
    if (_cacheMap.keys.contains(id)) {
      return _cacheMap[id];
    }
    return null;
  }

  @override
  Future<Map<int, JournalObject>> getAllJournals() async {
    return _cacheMap;
  }

  @override
  int getUniqueId() {
    return _uniqueId;
  }

  @override
  Future<void> open() async {
    Hive.registerAdapter(HiveJournalAdapter());
    _boxSingleJournal = await Hive.openBox<HiveJournal>('HiveJournal');
    _boxUniqueId = await Hive.openBox<HiveUniqueId>('HiveJournalUniqueId');
    loadCacheMap();
    _uniqueId = loadUniqueId();
  }

  @override
  Future<bool> remove(int id) async {
    if(_cacheMap.keys.contains(id)){
      _cacheMap.remove(id);
      _boxSingleJournal.delete(id);
      streamJournalController.add(_cacheMap);
      return true;
    }
    else{
      return false;
    }
  }

  @override
  Future<void> removeAll() {
    // doesn't work; 'concurrent modification during iteration'
    _cacheMap.clear();
    _boxSingleJournal.clear();
    _uniqueId = 0;
    _boxUniqueId.put(0, HiveUniqueId(id: 0));
    streamJournalController.add(_cacheMap);

    return Future(() => null);
  }

  @override
  Future<bool> update(JournalObject journalObject) async {
    // check presence
    if (_cacheMap.keys.contains(journalObject.getId())) {
      _cacheMap.addAll({journalObject.getId(): journalObject});
      streamJournalController.add(_cacheMap);

      //update in hivebox
      HiveJournal hj = HiveJournal(
          id: journalObject.getId(),
          body: journalObject.getBody(),
          dateOfCreation: journalObject.getDateOfCreation(),
          cardColorIntValue: journalObject.getCardColor().value
          );
          _boxSingleJournal.put(journalObject.getId(), hj);
          return true;
    }
    else{
      add(journalObject);
      return false;
    }
  }

  //
  // utility functions
  //        |
  //        ∨
  void loadCacheMap() {
    if (_boxSingleJournal.length > 0) {
      for (var k in _boxSingleJournal.keys) {
        HiveJournal hj = _boxSingleJournal.get(k);
        JournalObject journalObject = JournalObject(
            id: hj.id,
            body: hj.body,
            dateOfCreation: hj.dateOfCreation,
            cardColor: Color(hj.cardColorIntValue));
        _cacheMap.addAll({hj.id: journalObject});
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
