import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/settings/settings_object.dart';

abstract class SettingsService{
  @protected
final StreamController<Map<int,SettingsObject>> streamSettingsController = StreamController.broadcast();

Stream<Map<int, SettingsObject>> get stream => streamSettingsController.stream;

Future<void> dispose() async {
 streamSettingsController.close();
}

Future<SettingsObject?> get(int id);

int getUniqueId();

bool getTheme();

// Initialize the service
Future<void> open();

Future<bool> remove(int id);

Future<bool> update(SettingsObject settingsObject);
}