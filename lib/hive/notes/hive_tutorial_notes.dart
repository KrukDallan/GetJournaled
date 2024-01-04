import 'package:hive/hive.dart';


part 'hive_tutorial_notes.g.dart';

@HiveType(typeId: 5)
class HiveTutorialNotes extends HiveObject {
  @HiveField(0)
  late bool dismissed;

 
  HiveTutorialNotes({required this.dismissed});


  bool getDismissed(){
    return dismissed;
  }
}