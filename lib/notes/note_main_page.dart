

import 'package:flutter/material.dart';

import 'package:getjournaled/notes/note_view.dart';


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