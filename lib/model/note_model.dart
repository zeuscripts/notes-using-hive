import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dateCreated;

  @HiveField(3)
  final DateTime dateUpdated;

  Note({
    required this.content,
    required this.title,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        dateUpdated = dateUpdated ?? DateTime.now();
}
