import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/notes/note_object.dart';
import 'package:getjournaled/notes/note_card.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/scheduler.dart';

class NoteSearchPage extends StatefulWidget {
  const NoteSearchPage({super.key});

  @override
  State<NoteSearchPage> createState() => _NoteSearchPage();
}

class _NoteSearchPage extends State<NoteSearchPage> {
  final NoteService _notesService = GetIt.I<NoteService>();

  Map<int, NoteObject> _notesMap = {};

  final Map<int, NoteObject> _searchMathces = {};

  StreamSubscription? _noteSub;

  final TextEditingController _titleTextEditingController =
      TextEditingController();

  final FocusNode _myFocusNode = FocusNode();

  @override
  void dispose() {
    _noteSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _noteSub = _notesService.stream.listen(_onNotesUpdate);

    //
    // Display the alert dialog
    //
    SchedulerBinding.instance.addPostFrameCallback((_) {
      //ifLoaded();
    });
  }

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
                  // Search bar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 580),
                        curve: Curves.easeOutQuint,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.onPrimary),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.only(
                              top: 5.0, right: 4.0, left: 4.0, bottom: 5.0),
                          child: EditableText(
                            autofocus: true,
                            showCursor: true,
                            controller: _titleTextEditingController,
                            focusNode: _myFocusNode,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: colorScheme.onPrimary,
                            ),
                            cursorColor: colorScheme.onPrimary,
                            backgroundCursorColor: Colors.black,
                            onChanged: _onSearchBar,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 22.0,
                    icon: const Icon(
                      Icons.cancel_outlined,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 24)),
              // ---------------------------------------------------------------------------
              // Grid where notes are shown
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var entry in _searchMathces.entries) ...[
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
                                              _notesService.remove(entry.key);
                                            });
                                            Navigator.pop(context, 'Ok');
                                          }),
                                    ],
                                  );
                                });
                          },
                          child: NoteCard(
                            title: entry.value.getTitle(),
                            body: entry.value.getBody(),
                            id: entry.value.getId(),
                            dateOfCreation: entry.value.getDateOfCreation(),
                            dateOfLastEdit:entry.value.getDateOfLastEdit(),
                            cardColor:entry.value.getCardColor(),
                          ),
                        ),
                      ),
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

  void _onSearchBar(String text) {
    if (text == "" || text == " ") {
      _searchMathces.clear();
      setState(() {});
      return;
    }

    final lcText = text.toLowerCase();
    _searchMathces.clear();
    for (var j in _notesMap.entries) {
      var tmp = j.value;
      if (tmp.getTitle().toLowerCase().contains(lcText) ||
          tmp.getBody().toString().toLowerCase().contains(lcText)) {
        _searchMathces.addAll({j.key: j.value});
      }
    }
    setState(() {});
  }

  void _onNotesUpdate(Map<int, NoteObject> event) {
    /* setState(() {
      _notesMap = event;
    }); */
  }
}

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: const Drawer(),
    ));
  }
}
