import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/notes/new_note_single_page.dart';
import 'package:getjournaled/notes/note_object_class.dart';
import 'package:getjournaled/notes/note_view.dart';
import 'package:getjournaled/shared.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';


class WelcomePage extends StatefulWidget{
    const WelcomePage(
      {super.key,});

  @override
  State<StatefulWidget> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
    final NoteService _notesService = GetIt.I<NoteService>();

  Map<int, NoteObject> _notesMap = {};

  StreamSubscription? _notesSub;

  @override
  void dispose() {
    _notesSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    localUniqueId = (_notesMap.isNotEmpty) ? (_notesService.getUniqueId()) : 0;

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
        child: Container(
      decoration:  const BoxDecoration(
          color: Colors.black,
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: customTopPadding(0.1)),
          Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: Colors.amber.shade50,
                fontSize: 45,
                fontFamily: 'Lobster',
              ),
            ),
          ),
          Padding(padding: customTopPadding(0.4)),
          Container(
            height: 50,
            width: 200,
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.amber.shade50,
            ),
            child: TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => const Size(180, 50)),
              ),
              onPressed: () {},
              child: Text(
                'New journal',
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          Padding(padding: customTopPadding(0.05)),
          Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.amber.shade50,
            ),
            child: TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => const Size(180, 50)),
              ),
              onPressed: () {
                DateTime now = DateTime.now();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewNoteSinglePage(
                              title: '',
                              body: '',
                              id: _notesService.getUniqueId(),
                              lDateOfCreation: DateTime(now.year, now.month, now.day),
                              cardColor: Colors.deepOrange.shade200,
                            )));
              },
              child: Text(
                'New note',
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
    // business logic
  void _onNotesUpdate(Map<int,NoteObject> event) {
    setState(() {
      _notesMap = event;
    });
  }
}
