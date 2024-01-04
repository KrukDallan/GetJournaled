import 'package:hive/hive.dart';

part 'hive_notes.g.dart';

//
// Rules on how to add parameters: https://docs.hivedb.dev/#/custom-objects/generate_adapter
//

@HiveType(typeId: 1)
class HiveNotes extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String body;

  @HiveField(2)
  late int id;

  @HiveField(3)
  late DateTime dateOfCreation;

  @HiveField(4)
  late DateTime dateOfLastEdit;

  @HiveField(5)
  late int cardColorIntValue;

  HiveNotes(
      {required this.title,
      required this.body,
      required this.id,
      required this.dateOfCreation,
      required this.dateOfLastEdit,
      required this.cardColorIntValue});

  String getTitle() {
    return title;
  }

  String getBody() {
    return body;
  }

  int getId() {
    return id;
  }

  int getCardColor(){
    return cardColorIntValue;
  }
}
