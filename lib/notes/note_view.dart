import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/hive/notes/hive_tutorial_notes.dart';
import 'package:getjournaled/notes/note_object.dart';
import 'package:getjournaled/notes/note_search_page.dart';
import 'package:getjournaled/shared.dart';

import 'package:getjournaled/notes/note_card.dart';
import 'package:getjournaled/settings/settings_object.dart';
import 'package:getjournaled/db/abstraction/settings_service/settings_map_service.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _Notes();
}

class _Notes extends State<Notes> {
  final NoteService _notesService = GetIt.I<NoteService>();

  final SettingsService _settingsService = GetIt.I<SettingsService>();

  Map<int, NoteObject> _notesMap = {};

  StreamSubscription? _notesSub;

  StreamSubscription? _settingsSub;

  bool _darkTheme = true;

  @override
  void dispose() {
    _notesSub?.cancel();
    _settingsSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);
    _settingsSub = _settingsService.stream.listen(_onSettingsUpdate);
    _settingsService.get(0).then((value) => _darkTheme = value!.getDarkMode());

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
            child: Text(
              'Ok',
              style: TextStyle(
                color: (_darkTheme) ? Colors.white : Colors.black,
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
            child: Text(
              'Dismiss',
              style: TextStyle(
                color: (_darkTheme) ? Colors.white : Colors.black,
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
    var colorScheme = Theme.of(context).colorScheme;
    var _notes = <NoteObject>[];
    for (var entry in _notesMap.entries) {
      _notes.add(entry.value);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 24)),
              // ---------------------------------------------------------------------------
              // Title and search bar
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // ---------------------------------------------------------------------------
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 8.0),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const Expanded(child: Text('')),
                  // ---------------------------------------------------------------------------
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                    child: SizedBox(
                      width: 70,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NoteSearchPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_outlined,
                              size: 20,
                              color: colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 24)),
              // ---------------------------------------------------------------------------
              // Grid where notes are shown
              SingleChildScrollView(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  
                  children: [
                    for (var i = 0; i < _notes.length; i += 2) ...[
                      Row(
                        mainAxisAlignment: (_notes.length%2==0)? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: GestureDetector(
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
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: colorScheme.onPrimary,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                          ),
                                          TextButton(
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: colorScheme.onPrimary,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _notesService.remove(_notesMap
                                                      .entries
                                                      .firstWhere((element) =>
                                                          element.value ==
                                                          _notes[i])
                                                      .key);
                                                  leftPadding = 2;
                                                });
                                                Navigator.pop(context, 'Ok');
                                              }),
                                        ],
                                      );
                                    });
                              },
                              child: NoteCard(
                                title: _notes[i].getTitle(),
                                body: _notes[i].getBody(),
                                id: _notes[i].getId(),
                                dateOfCreation: _notes[i].getDateOfCreation(),
                                dateOfLastEdit: _notes[i].getDateOfLastEdit(),
                                cardColor: _notes[i].getCardColor(),
                              ),
                            ),
                          ),
                          if (i + 1 != _notes.length) ...{
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: GestureDetector(
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
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: colorScheme.onPrimary,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                            ),
                                            TextButton(
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _notesService.remove(
                                                        _notesMap.entries
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .value ==
                                                                    _notes[
                                                                        i + 1])
                                                            .key);
                                                    leftPadding = 2;
                                                  });
                                                  Navigator.pop(context, 'Ok');
                                                }),
                                          ],
                                        );
                                      });
                                },
                                child: NoteCard(
                                  title: _notes[i + 1].getTitle(),
                                  body: _notes[i + 1].getBody(),
                                  id: _notes[i + 1].getId(),
                                  dateOfCreation:
                                      _notes[i + 1].getDateOfCreation(),
                                  dateOfLastEdit:
                                      _notes[i + 1].getDateOfLastEdit(),
                                  cardColor: _notes[i + 1].getCardColor(),
                                ),
                              ),
                            )
                          }
                        ],
                      )
                    ],
                  ],
                ),
              )
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

  void _onSettingsUpdate(Map<int, SettingsObject> event) {
    setState(() {});
  }
}
