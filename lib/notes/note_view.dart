import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/hive/notes/hive_tutorial_notes.dart';
import 'package:getjournaled/notes/note_object.dart';
import 'package:getjournaled/shared.dart';

import 'package:getjournaled/notes/note_card.dart';
import 'package:hive/hive.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _Notes();
}

class _Notes extends State<Notes> {
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

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);

    //
    // Display the alert dialog
    //
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ifLoaded();
    });
  }

  //
  // function to use to display the alert dialog
  //
  void ifLoaded() {
    bool boxTutorialNotesValue = _notesService.getTutorialNotesValue();
    if (!boxTutorialNotesValue) {
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Quick guide'),
        content: const Text(
            ' • Single tap on a note to open it\n • Double tap to delete it\n • Hold to customize it\n • Your notes are automatically saved as you type'),
        actions: [
          TextButton(
            child: const Text(
              'Ok',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pop(context, 'Ok'),
          ),
          TextButton(
            onPressed: () {
              HiveTutorialNotes htn = HiveTutorialNotes(dismissed: true);
              _notesService.updateHiveTutorial(htn);
              Navigator.pop(context, 'Dismiss');
            },
            child: const Text(
              'Dismiss',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog;
          });
    }
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
              //
              // Title and search bar
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //
                  // Title
                  //
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 8.0),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.amber.shade50,
                      ),
                    ),
                  ),
                  const Expanded(child: Text('')),
                  //
                  // Search bar
                  //
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                    child: Container(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.only(left: 8.0)),
                          fixedSize: MaterialStateProperty.resolveWith((states) => const Size(280, 35)),
                        ),
                        onPressed: () {}, 
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Icon(
                                Icons.search_outlined,
                              size: 22,
                              color: Colors.white,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 90),
                            // 
                            // This should become an editable text
                            //
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            ),
                          ],
                        ))
                        ,
                      /* decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: IconButton(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          onPressed: () async {
                            _notesService.removeAll();
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 22.0,
                            color: Colors.white,
                          ),
                        ),
                      ), */
                    ),
                  ),
                ],
              ),
              Padding(padding: customTopPadding(0.05)),
              // 
              // Grid where notes are shown
              //
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 2.0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var entry in _notesMap.entries) ...[
                    GestureDetector(
                      onDoubleTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete note'),
                                content: const Text(
                                    'Are you sure you want to delete this note?'),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                  ),
                                  TextButton(
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _notesService.remove(entry.key);
                                          leftPadding = 2;
                                        });
                                        Navigator.pop(context, 'Ok');
                                      }),
                                ],
                              );
                            });
                      },
                      child: Padding(
                        padding: (leftPadding++ % 2 == 0)
                            ? const EdgeInsets.only(left: 10)
                            : const EdgeInsets.only(right: 10),
                        child: NoteCard(
                          title: entry.value.getTitle(),
                          body: entry.value.getBody(),
                          id: entry.value.getId(),
                          dateOfCreation: entry.value.getDateOfCreation(),
                          dateOfLastEdit: entry.value.getDateOfLastEdit(),
                          cardColor: entry.value.getCardColor(),
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
  void _onNotesUpdate(Map<int, NoteObject> event) {
    setState(() {
      _notesMap = event;
      leftPadding = 2;
    });
  }
}
