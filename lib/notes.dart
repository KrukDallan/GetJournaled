import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getjournaled/boxes.dart';
import 'package:getjournaled/main.dart';
import 'package:getjournaled/shared.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:getjournaled/hive_notes.dart';

int unique_id = 0;

class Notes extends StatefulWidget {
  @override
  State<Notes> createState() => _Notes();
}

class _Notes extends State<Notes> {
  void updateNoteView() {
    setState(() {});
  }

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
                  for (var entry in hiveNotesMap.entries)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: NoteCard(
                        title: entry.key,
                        body: entry.value,
                        id: hiveNotesIdMap.entries.firstWhere((element) => element.value==entry.key).key,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
  String title = '';
  String body = '';
  late int id;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
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
                    if (hiveNotesIdMap.containsKey(this.id)) {
                      hiveNotesMap.update(this.title, (value) => this.body);
                      HiveNotes hn =
                          HiveNotes(title: title, body: body, id: id);

                      // update the corresponding entry in the box
                      for (int i = 0; i < boxSingleNotes.length; i++) {
                        HiveNotes tmp = boxSingleNotes.getAt(i);
                        if (tmp.id == hn.id) {
                          boxSingleNotes.putAt(i, hn);
                          break;
                        }
                      }
                    } else {
                      HiveNotes hn =
                          HiveNotes(title: title, body: body, id: id);
                      hiveNotesMap.putIfAbsent(hn.title, () => hn.body);
                      boxSingleNotes.add(hn);
                    }
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
      child: Notes(),
    ));
  }
}
