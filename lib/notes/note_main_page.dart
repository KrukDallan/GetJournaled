import 'package:flutter/material.dart';

import 'package:getjournaled/notes/note_view.dart';


class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
        color: Colors.black,
          ),
      child: const Notes(),
    ));
  }
}