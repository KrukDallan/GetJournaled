import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/db/abstraction/journal_service/journal_map_service.dart';
import 'package:getjournaled/journals/new_journal_page.dart';
import 'package:getjournaled/notes/new_note_single_page.dart';
import 'package:getjournaled/shared.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  final NoteService _notesService = GetIt.I<NoteService>();

  StreamSubscription? _notesSub;

  final JournalService _journalService = GetIt.I<JournalService>();
  StreamSubscription? _journalSub;

  @override
  void dispose() {
    _notesSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
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
                DateTime now =DateTime.now();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewJournalPage(
                      id: _journalService.getUniqueId(), 
                      title: 'Title (optional)',
                      body: '', 
                      dateOfCreation: DateTime(now.year, now.month, now.day), 
                      cardColorIntValue: Colors.deepOrange.shade200.value, 
                      dayRating: -1, 
                      highlight: '', 
                      lowlight: '',
                      noteWorthy: '',)
                    )
                   );
              },
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
                              lDateOfCreation:
                                  DateTime(now.year, now.month, now.day),
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
}
