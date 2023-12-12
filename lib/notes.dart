import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getjournaled/main.dart';
import 'package:getjournaled/shared.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  @override
  State<Notes> createState() => _Notes();
}

class _Notes extends State<Notes> {
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
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: NoteCard(title: 'Title'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: NoteCard(title: 'Title'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: NoteCard(title: 'Title'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: NoteCard(title: 'Title'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: NoteCard(title: 'Title'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: NoteCard(title: 'Title'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: NoteCard(title: 'Title'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: NoteCard(title: 'Title'),
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

  NoteCard({super.key, required this.title});

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
                builder: (context) =>
                    SingleNotePage(title: widget.title, body: '')));
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

  SingleNotePage({super.key, required this.title, required this.body});

  @override
  State<StatefulWidget> createState() => _SingleNotePage();
}

class _SingleNotePage extends State<SingleNotePage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();
    return SafeArea(
        child: Container(
          color: colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 480 * 0.5 * 0.08, top: 800 * 0.5 * 0.02),
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            indent: 20,
            endIndent: 40,
          ),
          GestureDetector(
            onTap: () {},
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                child: EditableText(
                    controller: TextEditingController(text: ''),
                    focusNode: FocusNode(),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: colorScheme.onPrimary,
                    ),
                    maxLines: null,
                    cursorColor: colorScheme.onPrimary,
                    backgroundCursorColor: Color.fromARGB(255, 68, 67, 67)),
              ),
            ),
          )
        ],
      ),
    )

        /* Scaffold(
      backgroundColor: colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 480 * 0.5 * 0.08, top: 800 * 0.5 * 0.02),
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            indent: 20,
            endIndent: 40,
          ),
          SingleChildScrollView(
            child: GestureDetector(
            onTap: () { },
            child:
                LayoutBuilder(builder: (context, BoxConstraints constraints) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.9,
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                      child: EditableText(
                          controller: TextEditingController(text: ''),
                          focusNode: FocusNode(),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: colorScheme.onPrimary,
                          ),
                          maxLines: null,
                          cursorColor: colorScheme.onPrimary,
                          backgroundCursorColor: Color.fromARGB(255, 68, 67, 67)),
                    ),
                  ),
                );
            }),
          ),
          ),
        ],
      ),
    )*/
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
