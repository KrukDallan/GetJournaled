import 'package:flutter/material.dart';

class NoteObject {
  late int _id;
  late String _title;
  late dynamic _body;
  late DateTime _dateOfCreation;
  late DateTime _dateOfLastEdit;

  NoteObject(
      {required int id,
      required String title,
      required dynamic body,
      required DateTime dateOfCreation,
      required DateTime dateOfLastEdit})
      : _id = id,
        _title = title,
        _body = body,
        _dateOfCreation = dateOfCreation,
        _dateOfLastEdit = dateOfLastEdit;
}
