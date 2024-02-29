import 'package:hive/hive.dart';

part 'hive_settings.g.dart';

//
// Rules on how to add parameters: https://docs.hivedb.dev/#/custom-objects/generate_adapter
//

@HiveType(typeId: 6)
class HiveSettings extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late bool autosave;

  @HiveField(2)
  late bool darkmode;

  HiveSettings({required this.id, required this.autosave, required this.darkmode});

  int getId() {
    return id;
  }

  bool getAutosave() {
    return autosave;
  }

    bool getDarkmode() {
    return darkmode;
  }
}
