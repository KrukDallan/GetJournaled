import 'package:flutter/material.dart';

class SettingsObject extends Object{
  late int _id;
  late bool _autoSave;
  

  SettingsObject(
      {required int id,
        required bool autoSave,
      })
      : _id = id, 
      _autoSave = autoSave;

  int getId() {
    return _id;
  }

  int setId(int newValue) {
    int prev = _id;
    _id = newValue;
    return prev;
  }

  bool getAutoSave() {
    return _autoSave;
  }

  bool setAutoSave(bool newValue) {
    bool prev = _autoSave;
    _autoSave = newValue;
    return prev;
  }


  @override
  operator ==(Object other) => other is SettingsObject && other.runtimeType == runtimeType && other._id == _id && other._autoSave == _autoSave;
  
  @override
  int get hashCode => (_id.hashCode + _autoSave.hashCode);
  
}
