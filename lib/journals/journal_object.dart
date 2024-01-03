import 'package:flutter/material.dart';

class JournalObject extends Object{
  late int _id;
  late dynamic _body;
  late final DateTime _dateOfCreation;
  late Color _cardColor;

  JournalObject(
      {required int id,
      required dynamic body,
      required DateTime dateOfCreation,
      required Color cardColor,})
      : _id = id,
        _body = body,
        _dateOfCreation = dateOfCreation,
        _cardColor = cardColor;

  int getId() {
    return _id;
  }

  int setId(int newId) {
    int prev = _id;
    _id = newId;
    return prev;
  }

  dynamic getBody() {
    return _body;
  }

  dynamic setBody(dynamic newBody) {
    dynamic prev = _body;
    _body = newBody;
    return prev;
  }

  DateTime getDateOfCreation() {
    return _dateOfCreation;
  }

  Color getCardColor(){
    return _cardColor;
  }

  Color setCardColor(Color newCardColor) {
    Color tmp = _cardColor;
    _cardColor = newCardColor;
    return tmp;
  }

  @override
  operator ==(Object other) => other is JournalObject && other.runtimeType == runtimeType && other._id==_id && (!other._dateOfCreation.isAfter(_dateOfCreation) && !other._dateOfCreation.isBefore(_dateOfCreation));
  
  @override
  int get hashCode => (_id.hashCode + _body.hashCode + _dateOfCreation.hashCode);
  
}