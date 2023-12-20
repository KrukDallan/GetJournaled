import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/shared.dart';

int localUniqueId = 0;

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _Notes();
}

class _Notes extends State<Notes> {
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
              const Text(
                'Your notes',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
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
                  for (var entry in _notesMap.entries) ...[
                    Padding(
                      padding: (leftPadding++ % 2 == 0)
                          ? const EdgeInsets.only(left: 6)
                          : const EdgeInsets.only(right: 6),
                      child: NoteCard(
                        title: entry.value.keys.first,
                        body: entry.value.values.firstOrNull,
                        id: entry.key,
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
  void _onNotesUpdate(Map<int, Map<String, dynamic>> event) {
    setState(() {
      _notesMap = event;
    });
  }
}

class NoteCard extends StatefulWidget {
  late String title;
  late String body;
  late int id;

  NoteCard(
      {super.key, required this.title, required this.body, required this.id});

  @override
  State<StatefulWidget> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleNotePage(
                    title: widget.title, body: widget.body, id: widget.id)));
      },
      onLongPress: () {},
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
          width: 280,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade50,
                  Colors.orange.shade50,
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
            child: Center(
                child: Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
            )),
          ),
        ),
      ),
    );
  }
}

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
  String title = 'Title';
  String body = '';
  int id = 0;

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
    id = _notesService.getUniqueId();
  

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var oldBody = widget.body;
    title = widget.title;
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
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              const Expanded(child: Text('')),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, right: 10.0),
                child: OutlinedButton(
                  onPressed: () {
                    // check if the note is already present in the map
                    if ((_notesMap.isNotEmpty) &&
                        (_notesMap.containsKey(id))) {
                      Map<String, dynamic> tmp = {title: body};
                      _notesMap.update(id, (value) => tmp);
                      _notesService.update(id, tmp);
                      title = title;

                    } else {
                      Map<String, dynamic> tmp = {title: body};
                      _notesMap.putIfAbsent(id, () => tmp);
                      _notesService.add(id, tmp);
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
                left: 480 * 0.5 * 0.08, top: 800 * 0.5 * 0.02),
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
                  title = value;
                },
              ),
            ),
          ),
          const Divider(
            thickness: 1.0,
            indent: 20,
            endIndent: 40,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
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
                body = value;
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

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Colors.teal.shade200,
            Colors.purple[100]!,
          ])),
      child: const Notes(),
    ));
  }
}
