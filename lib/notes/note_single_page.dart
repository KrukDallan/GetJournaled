import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/notes/note_object.dart';
import 'package:getjournaled/shared.dart';

// TODO: insert date below note title
//       plus, save the date of creation and the last edit

class SingleNotePage extends StatefulWidget {
  late String title;
  late dynamic body;
  late int id;
  late DateTime dateOfCreation;
  late DateTime dateOfLastEdit;
  late Color cardColor;

  SingleNotePage(
      {super.key,
      required this.title,
      required this.body,
      required this.id,
      required this.dateOfCreation,
      required this.dateOfLastEdit,
      required this.cardColor});

  @override
  State<StatefulWidget> createState() => _SingleNotePage();
}

class _SingleNotePage extends State<SingleNotePage> {
  final NoteService _notesService = GetIt.I<NoteService>();

  Map<int, NoteObject> _notesMap = {};

  StreamSubscription? _notesSub;

  late TextEditingController _textEditingController;
  bool _makingList = false;

  List<String> _undoList = <String>[];
  List<String> _redoList = <String>[];
  late String
      _oldWidgetBody; // it should be dynamic.. not a problem until images can be inserted

  //
  // colored box
  //
  Color get boxColor => _boxColor;
  late Color _boxColor;
  set boxColor(Color value) {
    if (_boxColor != value) {
      setState(() {
        _boxColor = value;
      });
    }
  }

  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  final MenuController _menuController = MenuController();

  @override
  void dispose() {
    _notesSub?.cancel();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _boxColor = widget.cardColor;

    _notesService.getAllNotes().then((value) => setState(() {
          _notesMap = value;
        }));
    _notesSub = _notesService.stream.listen(_onNotesUpdate);
    _textEditingController = TextEditingController(text: widget.body);
    _oldWidgetBody = widget.body;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    _textEditingController = TextEditingController(text: widget.body);
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
                      color: Colors.grey.shade800,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: IconButton(
                          iconSize: 15.0,
                          padding: const EdgeInsets.only(bottom: 1.0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
                //
                // Undo button
                //
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 2.0),
                  child: IconButton(
                      onPressed: () {
                        if (_undoList.isNotEmpty) {
                          _redoList.add(widget.body);
                          setState(() {
                            _textEditingController.text =
                                _undoList.removeLast();
                            widget.body = _textEditingController.text;
                            _textEditingController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                        _textEditingController.text.length));
                          });
                        }
                      },
                      icon: Icon(
                        Icons.undo_rounded,
                        color: (_undoList.isEmpty)
                            ? Colors.grey.shade800
                            : Colors.white,
                      )),
                ),
                //
                // Redo button
                //
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 16.0),
                  child: IconButton(
                      onPressed: () {
                        if (_redoList.isNotEmpty) {
                          _undoList.add(widget.body);
                          setState(() {
                            _textEditingController.text =
                                _redoList.removeLast();
                            widget.body = _textEditingController.text;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.redo_rounded,
                        color: (_redoList.isEmpty)
                            ? Colors.grey.shade800
                            : Colors.white,
                      )),
                ),
                //
                // Save button
                //
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: IconButton(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        highlightColor: Colors.teal.shade200,
                        onPressed: () async {
                          _redoList.clear();
                          _undoList.clear();
                          while (true) {
                            if (widget.body.toString().endsWith('\n')) {
                              widget.body = widget.body.toString().replaceRange(
                                  widget.body.toString().length - 1,
                                  widget.body.toString().length,
                                  '');
                            } else {
                              break;
                            }
                          }
                          DateTime now = DateTime.now();
                          NoteObject noteObject = NoteObject(
                              id: widget.id,
                              title: widget.title,
                              body: widget.body,
                              dateOfCreation: widget.dateOfCreation,
                              dateOfLastEdit:
                                  DateTime(now.year, now.month, now.day),
                              cardColor: widget.cardColor);
                          // res==true? -> object updated, else object added (it was not present, shouldn't happen)
                          bool res = await _notesService.update(noteObject);
                          // check if the note is already present in the map
                          _notesMap.addAll({widget.id: noteObject});

                          setState(() {
                            widget.dateOfLastEdit =
                                DateTime(now.year, now.month, now.day);
                          });
                        },
                        icon: const Icon(
                          Icons.save_sharp,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
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
                    color: colorScheme.onPrimary,
                  ),
                  cursorColor: Colors.white,
                  backgroundCursorColor: Colors.black,
                  onChanged: (String value) {
                    widget.title = value;
                  },
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
                    padding: EdgeInsets.only(top: 8.0, left: 22.0),
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
                      'Last edit: ${widget.dateOfLastEdit.toString().replaceAll('00:00:00.000', '')}',
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
                controller: _textEditingController,
                focusNode: FocusNode(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: colorScheme.onPrimary,
                ),
                maxLines: null,
                cursorColor: Colors.white,
                backgroundCursorColor: const Color.fromARGB(255, 68, 67, 67),
                onChanged: _onTextChanged,
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _onTextChanged(String text) {
    if (text.endsWith('\n-')) {
      _makingList = true;
      _textEditingController.text = _textEditingController.text
          .replaceRange(text.length - 1, text.length, ' • ');
      _textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
      widget.body = _textEditingController.text;
    }
    if (_makingList == true) {
      if (text.endsWith(' • \n')) {
        _makingList = false;
        _textEditingController.text = _textEditingController.text
            .replaceRange(text.length - 4, text.length, '\n');
        _textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textEditingController.text.length));
        widget.body = _textEditingController.text;
      } else if (text.endsWith('\n') && (_makingList == true)) {
        _textEditingController.text += ' • ';
        _textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textEditingController.text.length));
        widget.body = _textEditingController.text;
      }
    }
    if (text != widget.body) {
      //
      // Updating the _undoList
      //
      _undoList.add(widget.body);
      widget.body = _textEditingController.text;

      setState(() {
        
      });
    }
  }

  // business logic
  void _onNotesUpdate(Map<int, NoteObject> event) {
    setState(() {
      _notesMap = event;
    });
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
