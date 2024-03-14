import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/db/abstraction/settings_service/settings_map_service.dart';
import 'package:getjournaled/notes/note_object.dart';
import 'package:getjournaled/shared.dart';
import 'package:getjournaled/settings/settings_object.dart';

class NewNoteSinglePage extends StatefulWidget {
  late String title;
  late String body;
  final int id;
  final DateTime lDateOfCreation;
  late Color cardColor;

  NewNoteSinglePage({
    super.key,
    required this.title,
    required this.body,
    required this.id,
    required this.lDateOfCreation,
    required this.cardColor,
  });

  @override
  State<StatefulWidget> createState() => _NewSingleNotePage();
}

class _NewSingleNotePage extends State<NewNoteSinglePage> {
  final NoteService _notesService = GetIt.I<NoteService>();

  SettingsService _settingsService = GetIt.I<SettingsService>();

  Map<int, NoteObject> _notesMap = {};

  StreamSubscription? _notesSub;

  StreamSubscription? _settingsSub;

  TextEditingController _bodyTextEditingController = TextEditingController();
  final MyTextInputFormatter _bodyTextInputFormatter = MyTextInputFormatter();
  final FocusNode _bodyFocusNode = FocusNode();

  //
  // Autosave data structures
  //
  bool _autoSave = false;

  List<String> _undoList = <String>[];
  ValueNotifier<Color> _undoColor = ValueNotifier(Colors.grey.shade800);
  List<String> _redoList = <String>[];
  ValueNotifier<Color> _redoColor = ValueNotifier(Colors.grey.shade800);
  late Color _activeUndoRedoColor;

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

  DateTime _lDateOfCreation = DateTime(0);

  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  final MenuController _menuController = MenuController();
  bool _menuWasEnabled = false;

  @override
  void dispose() {
    _notesSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _lDateOfCreation = widget.lDateOfCreation;

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _settingsService.get(0).then((value) => setState(() {}));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);
    _settingsSub = _settingsService.stream.listen(_onSettingsUpdate);
    _settingsService.get(0).then((value) => _autoSave = value!.getAutoSave());

    _bodyTextEditingController.addListener(() {});

    _oldTitle = widget.title;
    _oldBody = widget.body;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    _activeUndoRedoColor = colorScheme.onPrimary;
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
    });
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
        ),
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
                      color: (colorScheme.primary == Colors.black)
                          ? Colors.grey.shade800
                          : Colors.lightBlue.shade100,
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
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                          ),
                                          TextButton(
                                              child: const Text(
                                                'Leave',
                                                style: TextStyle(
                                                  color: Colors.white,
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
                                  _undoColor.value =
                                      (colorScheme.primary == Colors.black)
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade400;
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
                                    _redoColor.value =
                                        (colorScheme.primary == Colors.black)
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade400;
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
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
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
                            NoteObject noteObject = NoteObject(
                                id: widget.id,
                                title: widget.title,
                                body: widget.body,
                                dateOfCreation:
                                    DateTime(now.year, now.month, now.day),
                                dateOfLastEdit:
                                    DateTime(now.year, now.month, now.day),
                                cardColor: boxColor);
                            _notesService.add(noteObject);
                            _notesMap.addAll({widget.id: noteObject});
                            _oldBody = widget.body;
                            _oldTitle = widget.title;

                            //var mySnackBar = customSnackBar('Note saved!');
                            //ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
                          },
                          icon: const Icon(
                            Icons.save_sharp,
                            size: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                },
                //
                // Save button
                //
              ],
            ),
            //
            // Title
            //
            Padding(
              padding: const EdgeInsets.only(
                  left: 480 * 0.5 * 0.09, top: 800 * 0.5 * 0.02),
              child: Material(
                type: MaterialType.transparency,
                child: EditableText(
                  showCursor: true,
                  controller: TextEditingController(
                    text: widget.title,
                  ),
                  focusNode: FocusNode(),
                  style: TextStyle(
                      fontFamily: 'Roboto-Medium',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary),
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
                        'Created: ${_lDateOfCreation.toString().replaceAll('00:00:00.000', '')}'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, top: 8.0),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    child: Text(
                      '-',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    child: Text(
                      'Last edit: ${_lDateOfCreation.toString().replaceAll('00:00:00.000', '')}',
                    ),
                  ),
                )
              ],
            ),
            //
            // Body
            //
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 480 * 0.5 * 0.1, top: 10.0),
              child: EditableText(
                controller: _bodyTextEditingController,
                inputFormatters: [_bodyTextInputFormatter],
                focusNode: _bodyFocusNode,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: colorScheme.onPrimary,
                ),
                maxLines: null,
                showSelectionHandles: true,
                cursorColor: Colors.white,
                backgroundCursorColor: const Color.fromARGB(255, 68, 67, 67),
                onChanged: _onBodyChanged,
                readOnly: false,
                selectionColor: Colors.lightBlue.shade300,
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _onBodyChanged(String text) {
    if (text != widget.body) {
      _undoList.add(widget.body);
      _bodyTextEditingController.text = text;
      widget.body = _bodyTextEditingController.text;

      _bodyTextEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _bodyTextInputFormatter.getCursorOffset()));

      if (_autoSave) {
        _undoColor.value = _activeUndoRedoColor;
        DateTime now = DateTime.now();
        NoteObject noteObject = NoteObject(
            id: widget.id,
            title: widget.title,
            body: widget.body,
            dateOfCreation: widget.lDateOfCreation,
            dateOfLastEdit: DateTime(now.year, now.month, now.day),
            cardColor: widget.cardColor);
        _notesService.update(noteObject);
        // check if the note is already present in the map
        _notesMap.addAll({widget.id: noteObject});
      }
    }
  }
  void _onTitleChanged(String text) {
    if (text != widget.title) {
      widget.title = text;

      if (_autoSave) {
        _undoColor.value = _activeUndoRedoColor;
        DateTime now = DateTime.now();
        NoteObject noteObject = NoteObject(
            id: widget.id,
            title: widget.title,
            body: widget.body,
            dateOfCreation: widget.lDateOfCreation,
            dateOfLastEdit: DateTime(now.year, now.month, now.day),
            cardColor: widget.cardColor);
        _notesService.update(noteObject);
        // check if the note is already present in the map
        _notesMap.addAll({widget.id: noteObject});
      }
    }
  }

  // business logic
  void _onNotesUpdate(Map<int, NoteObject> event) {
    /* setState(() {
      _notesMap = event;
    }); */
  }

  void _onSettingsUpdate(Map<int, SettingsObject> event) {
    setState(() {});
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
      NoteObject noteObject = NoteObject(
          id: widget.id,
          title: widget.title,
          body: widget.body,
          dateOfCreation: widget.lDateOfCreation,
          dateOfLastEdit: widget.lDateOfCreation,
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
