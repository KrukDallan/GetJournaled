import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/db/abstraction/journal_service/journal_map_service.dart';
import 'package:getjournaled/db/abstraction/settings_service/settings_map_service.dart';
import 'package:getjournaled/journals/new_journal_page.dart';
import 'package:getjournaled/notes/new_note_single_page.dart';
import 'package:getjournaled/settings/settings_object.dart';
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

class _WelcomePage extends State<WelcomePage> with TickerProviderStateMixin {
  final NoteService _notesService = GetIt.I<NoteService>();

  StreamSubscription? _notesSub;

  final JournalService _journalService = GetIt.I<JournalService>();
  StreamSubscription? _journalSub;

  final SettingsService _settingsService = GetIt.I<SettingsService>();

  StreamSubscription? _settingsSub;

  double opacity = 1.0;

  var _darkTheme = true;

  @override
  void dispose() {
    _notesSub?.cancel();
    _settingsSub?.cancel();
    _journalSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _settingsSub = _settingsService.stream.listen(_onSettingsUpdate);
    _settingsService.get(0).then((value) => _darkTheme = value!.getDarkMode());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var welcomeColor = (colorScheme.primary == Colors.black)
        ? Colors.amber.shade50
        : Colors.lightBlue.shade200;

    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: customTopPadding(0.1)),
          Center(
            child: FadeTransition(
              opacity: AnimationController(
                vsync: this,
                value: opacity,
                duration: const Duration(milliseconds: 500),
              ),
              child: Text(
                'Welcome!',
                style: TextStyle(
                  color: welcomeColor,
                  fontSize: 45,
                  fontFamily: 'Lobster',
                ),
              ),
            ),
          ),
          Padding(padding: customTopPadding(0.4)),
          Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: welcomeColor,
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
                        builder: (context) => NewJournalPage(
                              id: _journalService.getUniqueId(),
                              title: 'Title (optional)',
                              body: '',
                              dateOfCreation:
                                  DateTime(now.year, now.month, now.day),
                              cardColor: Colors.lightBlue.shade100,
                              dayRating: 0,
                              highlight: '',
                              lowlight: '',
                              noteWorthy: '',
                            )));
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
              color: welcomeColor,
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
                              cardColor: Colors.lightBlue.shade100,
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

  void _onSettingsUpdate(Map<int, SettingsObject> event) {
    setState(() {});
  }
}
