import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/journal_service/journal_map_service.dart';
import 'package:getjournaled/journals/journal_object.dart';
import 'package:getjournaled/journals/journal_page.dart';
import 'package:getjournaled/shared.dart';

class DrawerCard extends StatefulWidget {
  late final int id;
  late String title;
  late String body;
  late DateTime dateOfCreation;
  late Color cardColor;
  late int dayRating;
  late String highlight;
  late String lowlight;
  late String noteWorthy;

  DrawerCard({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.dateOfCreation,
    required this.cardColor,
    required this.dayRating,
    required this.highlight,
    required this.lowlight,
    required this.noteWorthy,
  });

  @override
  State<StatefulWidget> createState() => _DrawerCardState();
}

class _DrawerCardState extends State<DrawerCard> {
  final JournalService _journalService = GetIt.I<JournalService>();

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

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        print(
            "Screen width: " + (MediaQuery.of(context).size.width).toString());
        print("Screen height: " +
            (MediaQuery.of(context).size.height).toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JournalPage(
                      id: widget.id,
                      title: widget.title,
                      body: widget.body,
                      dateOfCreation: widget.dateOfCreation,
                      cardColor: widget.cardColor,
                      dayRating: widget.dayRating,
                      highlight: widget.highlight,
                      lowlight: widget.lowlight,
                      noteWorthy: widget.noteWorthy,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                width: 250,
                height: 300,
                child: Card(
                  color: widget.cardColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
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
                          color: Colors.black,
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          widget.dateOfCreation
                              .toString()
                              .replaceAll('00:00:00.000', ''),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        //),
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
      JournalObject noteObject = JournalObject(
          id: widget.id,
          title: widget.title,
          body: widget.body,
          dateOfCreation: widget.dateOfCreation,
          cardColor: widget.cardColor,
          dayRating: widget.dayRating,
          highlight: widget.highlight,
          lowlight: widget.lowlight,
          noteWorthy: widget.noteWorthy);
      _journalService.update(noteObject);
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
