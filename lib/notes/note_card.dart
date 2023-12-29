import 'dart:math';

import 'package:flutter/material.dart';

import 'package:getjournaled/notes/note_single_page.dart';

class NoteCard extends StatefulWidget {
  late String title;
  late String body;
  late int id;
  late DateTime dateOfCreation;
  late DateTime dateOfLastEdit;

  NoteCard(
      {super.key,
      required this.title,
      required this.body,
      required this.id,
      required this.dateOfCreation,
      required this.dateOfLastEdit});

  @override
  State<StatefulWidget> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  Set<Color> colorsList = {
    Colors.green.shade200,
    Colors.lightBlue.shade100,
    Colors.deepOrange.shade200,
    Colors.teal.shade100,
    Colors.deepPurple.shade100
  };

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleNotePage(
                      title: widget.title,
                      body: widget.body,
                      id: widget.id,
                      dateOfCreation: widget.dateOfCreation,
                      dateOfLastEdit: widget.dateOfLastEdit,
                    )));
      },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SizedBox(
          width: 280,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: colorsList.elementAt(Random().nextInt(5)),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                    '${widget.dateOfLastEdit.toString().replaceAll('00:00:00.000', '')}',
                    style:  TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 12.0,
                    ),),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
