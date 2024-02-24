// TODO: una volta che l'utente ha compilato i campi, pusha le info nell'hive
// box, e prendile in "drawer.dart" o la classe che poi gestirà questo.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/journal_service/journal_map_service.dart';
import 'package:getjournaled/journals/journal_object.dart';
import 'package:getjournaled/shared.dart';

class NewJournalPage extends StatefulWidget {
  late int id;
  late String title;
  late String body;
  late DateTime dateOfCreation;
  late int cardColorIntValue;
  late int dayRating;
  late String highlight;
  late String lowlight;
  late String noteWorthy;

  NewJournalPage({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.dateOfCreation,
    required this.cardColorIntValue,
    required this.dayRating,
    required this.highlight,
    required this.lowlight,
    required this.noteWorthy,
  });

  @override
  State<StatefulWidget> createState() => _NewJournalPage();
}

class _NewJournalPage extends State<NewJournalPage> {
  TextEditingController _bodyTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  final MyTextInputFormatter _bodyTextInputFormatter = MyTextInputFormatter();
  final TitleTextInputFormatter _tTIF = TitleTextInputFormatter();

   ValueNotifier<String> tempTitle = ValueNotifier("Title (optional)");
   Color titleTextColor = Colors.grey.shade600;
  late ValueNotifier<Color> titleColor;

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

  final JournalService _journalService = GetIt.I<JournalService>();

  Map<int, JournalObject> _journalMap = {};

  StreamSubscription? _journalSub;

  Future<void> _disableContextMenu() async {}

  bool _menuWasEnabled = false;
  void _reenableContextMenu() {
    if (_menuWasEnabled && !BrowserContextMenu.enabled) {
      BrowserContextMenu.enableContextMenu();
    }
  }

  @override
  void dispose() {
    _journalSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _journalService.getAllJournals().then((value) => setState(() {
          _journalMap = value;
        }));
    _journalSub = _journalService.stream.listen(_onJournalsUpdate);
    _titleTextEditingController.text = widget.title;
    titleColor = ValueNotifier(titleTextColor);
  }


    

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
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
              ],
            ),
            //
            // Title
            //
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8),
              child: Material(
                  type: MaterialType.transparency,
                  child: EditableText(
                        showCursor: true,
                        controller: _titleTextEditingController,
                        inputFormatters: [_tTIF],
                        focusNode: FocusNode(),
                        style: TextStyle(
                          fontFamily: 'Roboto-Medium',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: ValueListenableBuilder(
                            valueListenable: titleColor,
                            builder: (BuildContext context, Color color, Widget? child) {
                              return Container(
                                color: titleColor.value,
                              );
                            },
                          ).valueListenable.value,
                        ),
                        cursorColor: colorScheme.onPrimary,
                        backgroundCursorColor: Colors.black,
                        onChanged: _onTitleTextChanged,
                      )
                    ),
                  ),
            //
            // Main body
            //
            const Padding(
              padding: EdgeInsets.only(top: 4.0, left: 18.0),
              child: Text('How was your day?'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Card(
                color: Colors.purple.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                    child: EditableText(
                      controller: _bodyTextEditingController,
                      inputFormatters: [_bodyTextInputFormatter],
                      focusNode: FocusNode(),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: colorScheme.onPrimary,
                      ),
                      maxLines: null,
                      cursorColor: colorScheme.onPrimary,
                      backgroundCursorColor:
                          const Color.fromARGB(255, 68, 67, 67),
                      onChanged: _onBodyTextChanged,
                    ),
                  ),
                ),
              ),
              //
              // Main body
              //
            ),
          ],
        ),
      ),
    ));
  }

  void _onBodyTextChanged(String text) {
    if (text != widget.body) {
      //_undoList.add(widget.body);
      _bodyTextEditingController.text = text;
      widget.body = _bodyTextEditingController.text;

      _bodyTextEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _bodyTextInputFormatter.getCursorOffset()));
    }
  }

  void _onTitleTextChanged(String text){

    if(!text.contains("Title (optional)")){
          print(text);
      titleColor.value = Colors.white;
      titleTextColor = Colors.white;
      setState(() {
        
      });
    }
    if(text != widget.title){
      _titleTextEditingController.text = text;
      widget.title = text;

      _titleTextEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _tTIF.getCursorOffset()));
    }
  }

  void _onJournalsUpdate(Map<int, JournalObject> event) {
    setState(() {
      _journalMap = event;
    });
  }
}
