import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/notes/note_object_class.dart';

class NewSingleNotePage extends StatefulWidget {
  late String title;
  late String body;
  late int id;
  late DateTime lDateOfCreation;

  NewSingleNotePage(
      {super.key,
      required this.title,
      required this.body,
      required this.id,
      required this.lDateOfCreation});

  @override
  State<StatefulWidget> createState() => _NewSingleNotePage();
}

class _NewSingleNotePage extends State<NewSingleNotePage> {
  String _title = '';
  String _body = '';
  late int _id;
  DateTime _lDateOfCreation = DateTime(0);

  final NoteService _notesService = GetIt.I<NoteService>();

  Map<int,NoteObject> _notesMap = {};

  StreamSubscription? _notesSub;

  @override
  void dispose() {
    _notesSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _lDateOfCreation = widget.lDateOfCreation;

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    _title = widget.title;
    _body = widget.body;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: IconButton(
                        iconSize: 15.0,
                        padding: const EdgeInsets.only(bottom: 1.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              const Expanded(child: Text('')),
              //
              // Save button
              //
              Padding(
                padding: const EdgeInsets.only(top: 4.0, right: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: IconButton(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      highlightColor: Colors.teal.shade200,
                      onPressed: () {
                        DateTime now = DateTime.now();
                        NoteObject noteObject = NoteObject(
                            id: widget.id,
                            title: _title,
                            body: _body,
                            dateOfCreation: DateTime(now.year, now.month, now.day),
                            dateOfLastEdit: DateTime(now.year, now.month, now.day));
                        _notesMap.addAll({widget.id:noteObject});
                        _notesService.add(noteObject);
                    
                        //var mySnackBar = customSnackBar('Note saved!');
                        //ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
                      },
                      icon: const Icon(
                        Icons.save_sharp,
                        size: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //
          // Title
          //
          Padding(
            padding: const EdgeInsets.only(
                left: 480 * 0.5 * 0.09, top: 800 * 0.5 * 0.02),
            child: Material(
              type: MaterialType.transparency,
              child: EditableText(
                controller: TextEditingController(
                  text: widget.title,
                ),
                focusNode: FocusNode(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary
                ),
                cursorColor: Colors.black,
                backgroundCursorColor: Colors.black,
                onChanged: (String value) {
                  _title = value;
                  widget.title = value;
                },
              ),
            ),
          ),
                    Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 22.0),
                child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                child: Text('Created: ${_lDateOfCreation.toString().replaceAll('00:00:00.000', '')}'),),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4.0, top: 8.0),
                child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                child: Text('-',),),
              ),
              Padding(
                padding:const EdgeInsets.only(left: 8.0, top: 8.0),
                child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                child: Text('Last edit: ${_lDateOfCreation.toString().replaceAll('00:00:00.000', '')}',),),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 480 * 0.5 * 0.1, top: 10.0),
            child: EditableText(
              controller: TextEditingController(text: widget.body),
              focusNode: FocusNode(),
              style:  TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: colorScheme.onPrimary,
              ),
              maxLines: null,
              cursorColor: Colors.black,
              backgroundCursorColor: const Color.fromARGB(255, 68, 67, 67),
              onChanged: (value) {
                _body = value;
                widget.body = value;
              },
            ),
          ))
        ],
      ),
    );
  }

  // business logic
  void _onNotesUpdate(Map<int,NoteObject> event) {
    setState(() {
      _notesMap = event;
    });
  }
}
