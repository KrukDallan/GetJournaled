import 'package:flutter/material.dart';

// rate your day (1-10)
// mood(s)
// highlight of the day
// lowlight of the day

class JournalObject extends Object {
  late int _id;
  late String _title;
  late dynamic _body;
  late final DateTime _dateOfCreation;
  late Color _cardColor;
  late int _dayRating;
  late String _highlight;
  late String _lowlight;
  late String _noteWorthy;

  JournalObject({
    required int id,
    required String title,
    required dynamic body,
    required DateTime dateOfCreation,
    required Color cardColor,
    required int dayRating,
    required String highlight,
    required String lowlight,
    required String noteWorthy,
  })  : _id = id,
        _title = title,
        _body = body,
        _dateOfCreation = dateOfCreation,
        _cardColor = cardColor,
        _dayRating = dayRating,
        _highlight = highlight,
        _lowlight = lowlight,
        _noteWorthy = noteWorthy;

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

  Color getCardColor() {
    return _cardColor;
  }

  Color setCardColor(Color newCardColor) {
    Color tmp = _cardColor;
    _cardColor = newCardColor;
    return tmp;
  }

  int getDayRating() {
    return _dayRating;
  }

  String getHighlight() {
    return _highlight;
  }

  String getLowlight() {
    return _lowlight;
  }

  String getNoteWorthy() {
    return _noteWorthy;
  }

  @override
  operator ==(Object other) =>
      other is JournalObject &&
      other.runtimeType == runtimeType &&
      other._id == _id &&
      (!other._dateOfCreation.isAfter(_dateOfCreation) &&
          !other._dateOfCreation.isBefore(_dateOfCreation));

  @override
  int get hashCode => (_id.hashCode +
      _body.hashCode +
      _dateOfCreation.hashCode +
      _cardColor.hashCode);
}
