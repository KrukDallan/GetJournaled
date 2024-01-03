import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getjournaled/notes/note_object.dart';

import 'package:getjournaled/notes/note_single_page.dart';
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';

//
// TODO: change MenuAnchor appearance
//

class NoteCard extends StatefulWidget {
  late String title;
  late String body;
  late int id;
  late DateTime dateOfCreation;
  late DateTime dateOfLastEdit;
  late Color cardColor;

  NoteCard(
      {super.key,
      required this.title,
      required this.body,
      required this.id,
      required this.dateOfCreation,
      required this.dateOfLastEdit,
      required this.cardColor});

  @override
  State<StatefulWidget> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final NoteService _notesService = GetIt.I<NoteService>();

  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  final MenuController _menuController = MenuController();

  Color get cardColor => _cardColor;
  late Color _cardColor;
  set cardColor(Color value) {
    if (_cardColor != value) {
      setState(() {
        _cardColor = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cardColor = widget.cardColor;
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  /* I don't know if I may need this
  void _reenableContextMenu() {
    if (_menuWasEnabled && !BrowserContextMenu.enabled) {
      BrowserContextMenu.enableContextMenu();
    }
  } */

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
                      cardColor: widget.cardColor,
                    )));
      },
      onLongPressStart: (pos) {
        _menuController.open(position: pos.localPosition);
      },
      child: MenuAnchor(
        controller: _menuController,
        anchorTapClosesMenu: true,
        menuChildren: <Widget>[
          SubmenuButton(
            menuChildren: <Widget>[
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorGreen),
                child: Text(MenuEntry.colorGreen.label),
              ),
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorLightBlue),
                child: Text(MenuEntry.colorLightBlue.label),
              ),
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorOrange),
                child: Text(MenuEntry.colorOrange.label),
              ),
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorPurple),
                child: Text(MenuEntry.colorPurple.label),
              ),
              MenuItemButton(
                onPressed: () => _activate(MenuEntry.colorTeal),
                child: Text(MenuEntry.colorTeal.label),
              ),
            ],
            child: const Text('Background Color'),
          ),
        ],
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SizedBox(
            width: 280,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: widget.cardColor,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        widget.dateOfLastEdit
                            .toString()
                            .replaceAll('00:00:00.000', ''),
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 12.0,
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _activate(MenuEntry selection) {
    Color tmp = widget.cardColor;

    switch (selection) {
      case MenuEntry.colorMenu:
        break;
      case MenuEntry.colorOrange:
        tmp = Colors.deepOrange.shade200;
      case MenuEntry.colorGreen:
        tmp = Colors.green.shade200;
      case MenuEntry.colorLightBlue:
        tmp = Colors.lightBlue.shade100;
      case MenuEntry.colorTeal:
        tmp = Colors.teal.shade100;
      case MenuEntry.colorPurple:
        tmp = Colors.deepPurple.shade100;
    }
    setState(() {
      widget.cardColor = tmp;
      NoteObject noteObject = NoteObject(
          id: widget.id,
          title: widget.title,
          body: widget.body,
          dateOfCreation: widget.dateOfCreation,
          dateOfLastEdit: widget.dateOfLastEdit,
          cardColor: widget.cardColor);
      _notesService.update(noteObject);
    });
  }

}

enum MenuEntry {
  colorMenu('Color Menu'),
  colorOrange(
    'Orange Card',
  ),
  colorGreen(
    'Green Card',
  ),
  colorLightBlue(
    'Lightblue Card',
  ),
  colorTeal(
    'Teal Card',
  ),
  colorPurple(
    'Purple Card',
  );

  const MenuEntry(this.label, [this.shortcut]);
  final String label;
  final MenuSerializableShortcut? shortcut;
}
