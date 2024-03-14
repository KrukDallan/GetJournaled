// TODO: una volta che l'utente ha compilato i campi, pusha le info nell'hive
// box, e prendile in "drawer.dart" o la classe che poi gestirà questo.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/journal_service/journal_map_service.dart';
import 'package:getjournaled/journals/journal_object.dart';
import 'package:getjournaled/settings/settings_object.dart';
import 'package:getjournaled/shared.dart';
import 'package:getjournaled/db/abstraction/settings_service/settings_map_service.dart';

class JournalPage extends StatefulWidget {
  late int id;
  late String title;
  late String body;
  late DateTime dateOfCreation;
  late Color cardColor;
  late int dayRating;
  late String highlight;
  late String lowlight;
  late String noteWorthy;

  JournalPage({
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
  State<StatefulWidget> createState() => _NewJournalPage();
}

class _NewJournalPage extends State<JournalPage> {
  final JournalService _journalService = GetIt.I<JournalService>();

  final SettingsService _settingsService = GetIt.I<SettingsService>();

  Map<int, JournalObject> _journalMap = {};

  StreamSubscription? _journalSub;

  StreamSubscription? _settingsSub;

  TextEditingController _bodyTextEditingController = TextEditingController();
  final TextEditingController _titleTextEditingController = TextEditingController();
  final MyTextInputFormatter _bTIF = MyTextInputFormatter();

  FocusNode myFocusNode = FocusNode();

  ValueNotifier<String> tempTitle = ValueNotifier("Title (optional)");
  Color titleTextColor = Colors.grey.shade600;
  late ValueNotifier<Color> titleColor;

  List<Color> rateButtonsColors = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black
  ];

  int rateIndex = 0;

  //
  // Autosave data structures
  //
  bool _autoSave = false;

  final List<String> _undoList = <String>[];
  final ValueNotifier<Color> _undoColor = ValueNotifier(Colors.grey.shade400);
  final List<String> _redoList = <String>[];
  final ValueNotifier<Color> _redoColor = ValueNotifier(Colors.grey.shade400);
  late Color _activeUndoRedoColor;

  final FocusNode _buttonFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();
  final MenuController _menuController = MenuController();

  // box card color
  Color get boxColor => _boxColor;
  Color _boxColor = Colors.deepOrange.shade200;
  set boxColor(Color value) {
    if (_boxColor != value) {
      setState(() {
        _boxColor = value;
      });
    }
  }

  late String _oldTitle;
  late String _oldBody;

  @override
  void dispose() {
    _journalSub?.cancel();
    _buttonFocusNode.dispose();
    _bodyFocusNode.dispose();
    _settingsSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _journalService.getAllJournals().then((value) => setState(() {
          _journalMap = value;
        }));

    _journalSub = _journalService.stream.listen(_onJournalsUpdate);
    _settingsSub = _settingsService.stream.listen(_onSettingsUpdate);
    _settingsService.get(0).then((value) => _autoSave = value!.getAutoSave());

    _bodyTextEditingController.addListener(() {});
    _bodyTextEditingController.text = widget.body;
    _titleTextEditingController.text = widget.title;
    titleColor = ValueNotifier(titleTextColor);
    _boxColor = widget.cardColor;

    _oldTitle = widget.title;
    _oldBody = widget.body;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    _activeUndoRedoColor = colorScheme.onPrimary;
    if(colorScheme.primary != Colors.black){
rateButtonsColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];
    }
    _bodyTextEditingController = TextEditingController(text: widget.body);
    setState(() {
      final String text = _bodyTextEditingController.text;
      _bodyTextEditingController.value =
          _bodyTextEditingController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.collapsed(text.length),
      );
      rateButtonsColors[widget.dayRating] = Colors.lightBlue.shade100;
    });
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (colorScheme.primary == Colors.black)? Colors.grey.shade800 : Colors.lightBlue.shade100,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: IconButton(
                          iconSize: 15.0,
                          padding: const EdgeInsets.only(bottom: 1.0),
                          onPressed: () {
                            if (_autoSave == false) {
                              if ((widget.title != _oldTitle) ||
                                  (widget.body != _oldBody)) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Exit?'),
                                        content: const Text(
                                            'You have unsaved changes, if you leave now they will be lost.'),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: colorScheme.onPrimary,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                          ),
                                          TextButton(
                                              child: Text(
                                                'Leave',
                                                style: TextStyle(
                                                  color: colorScheme.onPrimary,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, 'Ok');
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      );
                                    });
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: colorScheme.onPrimary, 
                          )),
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
                if (_autoSave) ...{
                  //
                  // Undo & Redo
                  //
                  Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: ValueListenableBuilder(
                        valueListenable: _undoColor,
                        builder:
                            (BuildContext context, Color color, Widget? child) {
                          return IconButton(
                            onPressed: () {
                              if (_undoList.isNotEmpty) {
                                if (_redoList.isEmpty) {
                                  _redoColor.value = colorScheme.onPrimary;
                                }
                                _redoList.add(_bodyTextEditingController.text);
                                _bodyTextEditingController.text =
                                    _undoList.removeLast();
                                widget.body = _bodyTextEditingController.text;
                                if (_undoList.isEmpty) {
                                  _undoColor.value = (colorScheme.primary == Colors.black)? Colors.grey.shade800 : Colors.grey.shade400;
                                }
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.undo_rounded,
                              color: color, // make color dynamic
                            ),
                          );
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                      child: ValueListenableBuilder(
                          valueListenable: _redoColor,
                          builder: (BuildContext context, Color color,
                              Widget? child) {
                            return IconButton(
                              onPressed: () {
                                if (_redoList.isNotEmpty) {
                                  if (_undoList.isEmpty) {
                                    _undoColor.value = colorScheme.onPrimary;
                                  }
                                  _undoList
                                      .add(_bodyTextEditingController.text);
                                  _bodyTextEditingController.text =
                                      _redoList.removeLast();
                                  widget.body = _bodyTextEditingController.text;
                                  if (_redoList.isEmpty) {
                                    _redoColor.value = (colorScheme.primary == Colors.black)? Colors.grey.shade800 : Colors.grey.shade400;
                                  }
                                  setState(() {});
                                }
                              },
                              icon: Icon(
                                Icons.redo_rounded,
                                color: color,
                              ),
                            );
                          })),
                },
                if (_autoSave == false) ...{
                  //
                  // Save button
                  //
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (colorScheme.primary == Colors.black)? Colors.grey.shade800 : Colors.lightBlue.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: IconButton(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          highlightColor: Colors.teal.shade200,
                          onPressed: () {
                            DateTime now = DateTime.now();
                            JournalObject noteObject = JournalObject(
                                id: widget.id,
                                title: widget.title,
                                body: widget.body,
                                dateOfCreation:
                                    DateTime(now.year, now.month, now.day),
                                cardColor: boxColor,
                                highlight: widget.highlight,
                                lowlight: widget.lowlight,
                                noteWorthy: widget.noteWorthy,
                                dayRating: rateIndex);
                            _journalService.add(noteObject);
                            _journalMap.addAll({widget.id: noteObject});
                            _oldBody = widget.body;
                            _oldTitle = widget.title;
                          },
                          icon: Icon(
                            Icons.save_sharp,
                            size: 18.0,
                            color: (colorScheme.primary == Colors.black)? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                },
              ],
            ),
            //
            // Title
            //
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Material(
                type: MaterialType.transparency,
                child: EditableText(
                  showCursor: true,
                  controller: TextEditingController(text: widget.title),
                  focusNode: FocusNode(),
                  style: TextStyle(
                    fontFamily: 'Roboto-Medium',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                  cursorColor: colorScheme.onPrimary,
                  backgroundCursorColor: Colors.black,
                  onChanged: _onTitleChanged,
                ),
              ),
            ),
            //
            // Color box
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTapDown: (pos) {
                    _menuController.open(position: pos.localPosition);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 22.0),
                    child: Container(
                      color: Colors.white,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: Container(
                              color: boxColor,
                              child: MenuAnchor(
                                controller: _menuController,
                                anchorTapClosesMenu: true,
                                menuChildren: <Widget>[
                                  MenuItemButton(
                                    onPressed: () =>
                                        _activate(MenuEntry.colorGreen),
                                    child: Text(MenuEntry.colorGreen.label),
                                  ),
                                  MenuItemButton(
                                    onPressed: () =>
                                        _activate(MenuEntry.colorLightBlue),
                                    child: Text(MenuEntry.colorLightBlue.label),
                                  ),
                                  MenuItemButton(
                                    onPressed: () =>
                                        _activate(MenuEntry.colorOrange),
                                    child: Text(MenuEntry.colorOrange.label),
                                  ),
                                  MenuItemButton(
                                    onPressed: () =>
                                        _activate(MenuEntry.colorPurple),
                                    child: Text(MenuEntry.colorPurple.label),
                                  ),
                                  MenuItemButton(
                                    onPressed: () =>
                                        _activate(MenuEntry.colorTeal),
                                    child: Text(MenuEntry.colorTeal.label),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //
            // Dates
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 22.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    child: Text(
                        'Created: ${widget.dateOfCreation.toString().replaceAll('00:00:00.000', '')}'),
                  ),
                ),
              ],
            ),
            //
            // Main section
            //
            const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 22.0),
              child: Text('How was your day?'),
            ),
            // Day rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, left: 4.0, right: 0.0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => rateButtonsColors[0]),
                      ),
                      onPressed: () {
                        for (var i = 0; i < rateButtonsColors.length; i++) {
                          rateButtonsColors[i] = colorScheme.primary;
                        }
                        rateButtonsColors[0] = Colors.lightBlue.shade100;
                        rateIndex = 0;
                        setState(() {
                          widget.dayRating = rateIndex;
                          JournalObject journalObject = JournalObject(
                            id: widget.id,
                            title: widget.title,
                            body: widget.body,
                            dateOfCreation: widget.dateOfCreation,
                            cardColor: widget.cardColor,
                            dayRating: widget.dayRating,
                            highlight: widget.highlight,
                            lowlight: widget.lowlight,
                            noteWorthy: widget.noteWorthy,
                          );
                          _journalService.update(journalObject);
                        });
                      },
                      child: Text(
                        "Terrible\n (╥_╥)",
                        style: TextStyle(
                            color: (rateButtonsColors[0] == colorScheme.primary)
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, left: 0.0, right: 0.0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => rateButtonsColors[1]),
                      ),
                      onPressed: () {
                        for (var i = 0; i < rateButtonsColors.length; i++) {
                          rateButtonsColors[i] = colorScheme.primary;
                        }
                        rateButtonsColors[1] = Colors.lightBlue.shade100;
                        rateIndex = 1;
                        setState(() {
                          widget.dayRating = rateIndex;
                          JournalObject journalObject = JournalObject(
                            id: widget.id,
                            title: widget.title,
                            body: widget.body,
                            dateOfCreation: widget.dateOfCreation,
                            cardColor: widget.cardColor,
                            dayRating: widget.dayRating,
                            highlight: widget.highlight,
                            lowlight: widget.lowlight,
                            noteWorthy: widget.noteWorthy,
                          );
                          _journalService.update(journalObject);
                        });
                      },
                      child: Text(
                        "Not so good\n ┐(´～｀)┌",
                        style: TextStyle(
                          color: (rateButtonsColors[1] == colorScheme.primary)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                        ),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, left: 0.0, right: 0.0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => rateButtonsColors[2]),
                      ),
                      onPressed: () {
                        for (var i = 0; i < rateButtonsColors.length; i++) {
                          rateButtonsColors[i] = colorScheme.primary;
                        }
                        rateButtonsColors[2] = Colors.lightBlue.shade100;
                        rateIndex = 2;
                        setState(() {
                          widget.dayRating = rateIndex;
                          JournalObject journalObject = JournalObject(
                            id: widget.id,
                            title: widget.title,
                            body: widget.body,
                            dateOfCreation: widget.dateOfCreation,
                            cardColor: widget.cardColor,
                            dayRating: widget.dayRating,
                            highlight: widget.highlight,
                            lowlight: widget.lowlight,
                            noteWorthy: widget.noteWorthy,
                          );
                          _journalService.update(journalObject);
                        });
                      },
                      child: Text(
                        "Normal\n  ( ﾟｰﾟ)",
                        style: TextStyle(
                          color: (rateButtonsColors[2] == colorScheme.primary)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                        ),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, left: 0.0, right: 0.0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => rateButtonsColors[3]),
                      ),
                      onPressed: () {
                        for (var i = 0; i < rateButtonsColors.length; i++) {
                          rateButtonsColors[i] = colorScheme.primary;
                        }
                        rateButtonsColors[3] = Colors.lightBlue.shade100;
                        rateIndex = 3;
                        setState(() {
                          widget.dayRating = rateIndex;
                          JournalObject journalObject = JournalObject(
                            id: widget.id,
                            title: widget.title,
                            body: widget.body,
                            dateOfCreation: widget.dateOfCreation,
                            cardColor: widget.cardColor,
                            dayRating: widget.dayRating,
                            highlight: widget.highlight,
                            lowlight: widget.lowlight,
                            noteWorthy: widget.noteWorthy,
                          );
                          _journalService.update(journalObject);
                        });
                      },
                      child: Text(
                        "     Good!\n （＾ｖ＾）",
                        style: TextStyle(
                          color: (rateButtonsColors[3] == colorScheme.primary)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                        ),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, left: 0.0, right: 8.0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => rateButtonsColors[4]),
                      ),
                      onPressed: () {
                        for (var i = 0; i < rateButtonsColors.length; i++) {
                          rateButtonsColors[i] = colorScheme.primary;
                        }
                        rateButtonsColors[4] = Colors.lightBlue.shade100;
                        rateIndex = 4;
                        setState(() {
                          widget.dayRating = rateIndex;
                          JournalObject journalObject = JournalObject(
                            id: widget.id,
                            title: widget.title,
                            body: widget.body,
                            dateOfCreation: widget.dateOfCreation,
                            cardColor: widget.cardColor,
                            dayRating: widget.dayRating,
                            highlight: widget.highlight,
                            lowlight: widget.lowlight,
                            noteWorthy: widget.noteWorthy,
                          );
                          _journalService.update(journalObject);
                        });
                      },
                      child: Text(
                        " Very good!\n˖✧◝(⁰▿⁰)◜✧˖",
                        style: TextStyle(
                          color: (rateButtonsColors[4] == colorScheme.primary)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                        ),
                      )),
                ),
              ],
            ),
            //
            // Body
            //
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 26.0, top: 10.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.height * 80 / 100,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  border: Border.all(
                    color: colorScheme.onPrimary,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: EditableText(
                  controller: _bodyTextEditingController,
                  inputFormatters: [_bTIF],
                  focusNode: _bodyFocusNode,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: colorScheme.onPrimary,
                  ),
                  maxLines: null,
                  cursorColor: colorScheme.onPrimary,
                  backgroundCursorColor: const Color.fromARGB(255, 68, 67, 67),
                  onChanged: _onBodyChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _onBodyChanged(String text) {
    if (text != widget.body) {
      _undoList.add(widget.body);
      _bodyTextEditingController.text = text;
      widget.body = _bodyTextEditingController.text;

      _bodyTextEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _bTIF.getCursorOffset()));

      if (_autoSave) {
        _undoColor.value = _activeUndoRedoColor;
        JournalObject journalObject = JournalObject(
          id: widget.id,
          title: widget.title,
          body: widget.body,
          dateOfCreation: widget.dateOfCreation,
          cardColor: widget.cardColor,
          highlight: widget.highlight,
          lowlight: widget.lowlight,
          noteWorthy: widget.noteWorthy,
          dayRating: widget.dayRating,
        );
        _journalService.update(journalObject);
        // check if the note is already present in the map
        _journalMap.addAll({widget.id: journalObject});
      }
    }
  }

  void _onTitleChanged(String text) {
    if (text != widget.title) {
      widget.title = text;

      if (_autoSave) {
        _undoColor.value = _activeUndoRedoColor;
        JournalObject journalObject = JournalObject(
          id: widget.id,
          title: widget.title,
          body: widget.body,
          dateOfCreation: widget.dateOfCreation,
          cardColor: widget.cardColor,
          highlight: widget.highlight,
          lowlight: widget.lowlight,
          noteWorthy: widget.noteWorthy,
          dayRating: widget.dayRating,
        );
        _journalService.update(journalObject);
        // check if the note is already present in the map
        _journalMap.addAll({widget.id: journalObject});
      }
    }
  }

  void _onJournalsUpdate(Map<int, JournalObject> event) {
/*     setState(() {
      _journalMap = event;
    }); */
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
      boxColor = tmp;
      JournalObject journalObject = JournalObject(
        id: widget.id,
        title: widget.title,
        body: widget.body,
        dateOfCreation: widget.dateOfCreation,
        cardColor: widget.cardColor,
        dayRating: widget.dayRating,
        highlight: widget.highlight,
        lowlight: widget.lowlight,
        noteWorthy: widget.noteWorthy,
      );
      _journalService.update(journalObject);
    });
  }

  void _onSettingsUpdate(Map<int, SettingsObject> event) {
    setState(() {});
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
