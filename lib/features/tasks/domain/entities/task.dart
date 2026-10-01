import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;
  final bool isImportant;
  final String categoryId;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
    required this.isImportant,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    isCompleted,
    isImportant,
    categoryId,
  ];
}
