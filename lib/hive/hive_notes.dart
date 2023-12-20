import 'package:hive/hive.dart';


part 'hive_notes.g.dart';

@HiveType(typeId: 1)
class HiveNotes extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String body;

  @HiveField(2)
  late int id;

  HiveNotes({required this.title, required this.body, required this.id});

  String getTitle(){
    return title;
  }

  String getBody(){
    return body;
  }

  int getId(){
    return id;
  }
}