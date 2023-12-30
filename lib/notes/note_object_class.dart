import 'package:flutter/material.dart';

class NoteObject extends Object{
  late int _id;
  late String _title;
  late dynamic _body;
  late final DateTime _dateOfCreation;
  late DateTime _dateOfLastEdit;
  late Color _cardColor;

  NoteObject(
      {required int id,
      required String title,
      required dynamic body,
      required DateTime dateOfCreation,
      required DateTime dateOfLastEdit,
      required Color cardColor,})
      : _id = id,
        _title = title,
        _body = body,
        _dateOfCreation = dateOfCreation,
        _dateOfLastEdit = dateOfLastEdit,
        _cardColor = cardColor;

  int getId() {
    return _id;
  }

  int setId(int newId) {
    int prev = _id;
    _id = newId;
    return prev;
  }

  String getTitle() {
    return _title;
  }

  String setTitle(String newTitle) {
    String prev = _title;
    _title = newTitle;
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

  DateTime getDateOfLastEdit() {
    return _dateOfLastEdit;
  }

  DateTime setDateOfLastEdit(DateTime newDate){
    DateTime prev = _dateOfLastEdit;
    _dateOfLastEdit = newDate;
    return prev;
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
  operator ==(Object other) => other is NoteObject && other.runtimeType == runtimeType && other._id==_id && other._title == _title && (!other._dateOfCreation.isAfter(_dateOfCreation) && !other._dateOfCreation.isBefore(_dateOfCreation));
  
  @override
  int get hashCode => (_id.hashCode + _title.hashCode + _body.hashCode + _dateOfCreation.hashCode + _dateOfLastEdit.hashCode);
  
}
