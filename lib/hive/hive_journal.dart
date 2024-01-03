import 'package:hive/hive.dart';

part 'hive_journal.g.dart';

//
// Rules on how to add parameters: https://docs.hivedb.dev/#/custom-objects/generate_adapter
//

@HiveType(typeId: 3)
class HiveJournal extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String body;

  @HiveField(3)
  late DateTime dateOfCreation;

  @HiveField(6)
  late int cardColorIntValue;

  HiveJournal(
      {required this.id,
      required this.body,
      required this.dateOfCreation,
      required this.cardColorIntValue});

  int getId() {
    return id;
  }

  String getBody() {
    return body;
  }

  int getCardColor() {
    return cardColorIntValue;
  }
}
