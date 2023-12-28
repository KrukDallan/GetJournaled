import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/notes/note_object_class.dart';
import 'package:getjournaled/shared.dart';

import 'package:getjournaled/notes/note_card.dart';

int localUniqueId = 0;

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _Notes();
}

class _Notes extends State<Notes> {
  final NoteService _notesService = GetIt.I<NoteService>();

  Set<NoteObject> _notesSet = {};

  StreamSubscription? _notesSub;

  @override
  void dispose() {
    _notesSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    localUniqueId = (_notesSet.isNotEmpty) ? (_notesService.getUniqueId()) : 0;

    _notesService.getAllNotes().then((value) => setState(() {
          _notesSet = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);


  }

  int leftPadding = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: customTopPadding(0.025)),
               const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your notes',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  /* levatedButton(
                    onPressed: () => _notesService.removeAll(), 
                    child: const Icon(Icons.delete_forever)
                    ), */
                ],
              ),
              Padding(padding: customTopPadding(0.1)),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 10.0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var entry in _notesSet) ...[
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _notesService.remove(entry.getId());
                          leftPadding = 2;
                        });
                      },
                      child: Padding(
                        padding: (leftPadding++ % 2 == 0)
                            ? const EdgeInsets.only(left: 10)
                            : const EdgeInsets.only(right: 10),
                        child: NoteCard(
                          title: entry.getTitle(),
                          body: entry.getBody(),
                          id: entry.getId(),
                          dateOfCreation: entry.getDateOfCreation(),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // business logic
  void _onNotesUpdate(Set<NoteObject> event) {
    setState(() {
      _notesSet = event;
    });
  }
}