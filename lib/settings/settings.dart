import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_service/note_map_service.dart';
import 'package:getjournaled/db/abstraction/settings_service/settings_map_service.dart';
import 'package:getjournaled/settings/settings_object.dart';
import 'package:getjournaled/main.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  bool _autoSave = false;
  bool _darkMode = false;

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
          _darkMode = _settingsMap[0]!.getDarkMode();
        }));
    _settingsSub = _settingsService.stream.listen(_onSettingsUpdate);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var settingsCardColor = (_darkMode)? Colors.grey.shade900 : const Color.fromARGB(255, 231, 240, 243);
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: settingsCardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Use autosave',
                      style:
                          TextStyle(
                            fontFamily: 'Roboto', 
                            color: colorScheme.onPrimary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Switch(
                        value: _autoSave,
                        onChanged: (onChanged) {
                          _autoSave = !_autoSave;
                          SettingsObject settingsObject = SettingsObject(
                              id: 0, autoSave: onChanged, darkMode: _darkMode);
                          _settingsService.update(settingsObject);
                        }),
                  ),
                ],
              ),
            ),
            Card(
              color: settingsCardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enable darkmode',
                      style:
                          TextStyle(
                            fontFamily: 'Roboto', 
                            color: colorScheme.onPrimary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Switch(
                        value: _darkMode,
                        onChanged: (onChanged) {
                          (_darkMode)
                              ? MyApp.of(context).changeTheme(ThemeMode.light)
                              : MyApp.of(context).changeTheme(ThemeMode.dark);
                          _darkMode = !_darkMode;
                          SettingsObject settingsObject = SettingsObject(
                              id: 0, autoSave: _autoSave, darkMode: onChanged);
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
