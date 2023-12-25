import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/main.dart';
import 'package:getjournaled/notes/note_main_page.dart';
import 'package:getjournaled/shared.dart';

class SingleNotePage extends StatefulWidget {
  late String title;
  late String body;
  late int id;

  SingleNotePage(
      {super.key, required this.title, required this.body, required this.id});

  @override
  State<StatefulWidget> createState() => _SingleNotePage();
}

class _SingleNotePage extends State<SingleNotePage> {
  String _title = 'Title';
  String _body = '';
  int _id = -1;

  final NoteMapsService _notesService = GetIt.I<NoteMapsService>();

  Map<int, Map<String, dynamic>> _notesMap = {};

  StreamSubscription? _notesSub;

  @override
  void dispose() {
    _notesSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
   if (_id == -1){
     _id = widget.id;
     _title = widget.title;
     _body = widget.body;
   }

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    _title = widget.title;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.amber.shade50,
          Colors.orange.shade50,
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      
                      /* Navigator.push(context,  MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'GetClocked', page: NotesPage(),))); */
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              const Expanded(child: Text('')),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, right: 10.0),
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.deepOrange.shade200),
                  ),
                  onPressed: () {
                    Map<String, dynamic> tmp = {_title: _body};
                    _notesService.update(_id, tmp);
                    // check if the note is already present in the map
                    if ((_notesMap.isNotEmpty) && (_notesMap.containsKey(_id))) {
                      _notesMap.update(_id, (value) => tmp);
                    } else {
                      _notesMap.putIfAbsent(_id, () => tmp);
                    }
                    //var mySnackBar = customSnackBar('Note saved!');
                    //ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
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
          const Divider(
            thickness: 1.0,
            indent: 17,
            endIndent: 80,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 480 * 0.5 * 0.09, top: 10.0),
            child: EditableText(
              controller: TextEditingController(text: widget.body),
              focusNode: FocusNode(),
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.black,
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
  void _onNotesUpdate(Map<int, Map<String, dynamic>> event) {
    setState(() {
      _notesMap = event;
    });
  }
}

