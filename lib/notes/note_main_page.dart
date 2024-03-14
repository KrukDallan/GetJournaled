import 'package:flutter/material.dart';

import 'package:getjournaled/notes/note_view.dart';


class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
          ),
      child: const Notes(),
    ));
  }
}