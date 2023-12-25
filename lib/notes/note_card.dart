import 'package:flutter/material.dart';

import 'package:getjournaled/notes/note_single_page.dart';


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
                    title: widget.title, body: widget.body, id: widget.id))).then((value) => setState((){ }));
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