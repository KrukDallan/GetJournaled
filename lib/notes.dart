import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';


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
              const Text('Your notes',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700 ,
              ),),
              Padding(padding: customTopPadding(0.1)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NoteCard(title: 'Title'),
                    NoteCard(title: 'Title2'),
                  ],
                ),
              )
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
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: 
          SizedBox(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: customTopPadding(0.02)),
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    )
                    ),
                ],
              )
              ),
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