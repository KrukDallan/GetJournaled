import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/notes/new_note_page.dart';
import 'package:getjournaled/notes/note_view.dart';
import 'package:getjournaled/shared.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_map_service.dart';


class WelcomePage extends StatefulWidget{
    const WelcomePage(
      {super.key,});

  @override
  State<StatefulWidget> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
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
    localUniqueId = (_notesMap.isNotEmpty) ? (_notesMap.keys.last +1) : 0;

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
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Colors.amberAccent[200]!,
            Colors.purple[200]!,
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: customTopPadding(0.1)),
          Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 45,
                fontFamily: 'Lobster',
              ),
            ),
          ),
          Padding(padding: customTopPadding(0.4)),
          Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade100,
                  Colors.purple.shade100,
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
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
                  color: colorScheme.onPrimary,
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
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade100,
                  Colors.purple.shade100,
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
            child: TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => const Size(180, 50)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewSingleNotePage(
                              title: 'Title',
                              body: '',
                              id: _notesService.getUniqueId(),
                            )));
              },
              child: Text(
                'New note',
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
    // business logic
  void _onNotesUpdate(Map<int, Map<String, dynamic>> event) {
    setState(() {
      _notesMap = event;
    });
  }
}
