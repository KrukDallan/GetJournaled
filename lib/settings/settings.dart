import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/db/abstraction/settings_service/settings_map_service.dart';
import 'package:getjournaled/settings/settings_object.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  bool _autoSave = false;

  final SettingsService _settingsService = GetIt.I<SettingsService>();

  Map<int, SettingsObject> _settingsMap = {};

  StreamSubscription? _settingsSub;

  @override
  void dispose() {
    _settingsSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _settingsService.get(0).then((value) => setState(() {
          _settingsMap.addAll({0: value!});
          _autoSave = _settingsMap[0]!.getAutoSave();
        }));
    _settingsSub = _settingsService.stream.listen(_onSettingsUpdate);

  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey.shade900,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Use autosave',
                      style:
                          TextStyle(fontFamily: 'Roboto', color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Switch(
                        value: _autoSave,
                        onChanged: (onChanged) {
                          _autoSave = !_autoSave;
                          SettingsObject settingsObject =
                              SettingsObject(id: 0, autoSave: onChanged);
                          _settingsService.update(settingsObject);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _onSettingsUpdate(Map<int, SettingsObject> event) {
    setState(() {
      _settingsMap = event;
    });
  }
}
