
import 'package:hive/hive.dart';

part 'modelclass.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String dueDate;

  Task({required this.title, required this.description, required this.dueDate});
}
