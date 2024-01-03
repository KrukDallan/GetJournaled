import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
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

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ifLoaded();
    });
  }

  void ifLoaded() async {
    if(_notesService.getUniqueId() == 0 ){
      AlertDialog alertDialog = AlertDialog(
      title: const Text('Quick guide'),
      content: const Text(
          ' • Single tap on a note to open it\n • Double tap to delete it\n • Hold to customize it'),
      actions: [
        TextButton(
          child: const Text('Ok',
          style: TextStyle(
            color: Colors.white,
          ),),
          onPressed: () => Navigator.pop(context, 'Ok'),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });}
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  /* ElevatedButton(
                    onPressed: () => _notesService.removeAll(), 
                    child: const Icon(Icons.delete_forever)
                    ), */
                  const Expanded(child: Text('')),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
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
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: customTopPadding(0.05)),
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
                        setState(() {
                          _notesService.remove(entry.key);
                          leftPadding = 2;
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
