

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
}
