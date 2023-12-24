import 'package:hive/hive.dart';


part 'hive_unique_id.g.dart';

@HiveType(typeId: 2)
class HiveUniqueId extends HiveObject {
  @HiveField(0)
  late int id;

 
  HiveUniqueId({required this.id});


  int getId(){
    return id;
  }
}