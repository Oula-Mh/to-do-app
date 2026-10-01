import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/task.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    required super.isCompleted,
    required super.isImportant,
    required super.categoryId,
  });

  factory TaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    if (data == null) {
      throw Exception('Task data is empty');
    }

    final dateValue = data['date'];

    DateTime taskDate;

    if (dateValue is Timestamp) {
      taskDate = dateValue.toDate();
    } else if (dateValue is String) {
      taskDate = DateTime.parse(dateValue);
    } else {
      throw Exception('Invalid task date');
    }

    return TaskModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      date: taskDate,
      isCompleted: data['isCompleted'] as bool? ?? false,
      isImportant: data['isImportant'] as bool? ?? false,
      categoryId: data['categoryId'] as String? ?? '',
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final dateValue = json['date'];

    DateTime taskDate;

    if (dateValue is Timestamp) {
      taskDate = dateValue.toDate();
    } else if (dateValue is String) {
      taskDate = DateTime.parse(dateValue);
    } else {
      throw Exception('Invalid task date');
    }

    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: taskDate,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isImportant: json['isImportant'] as bool? ?? false,
      categoryId: json['categoryId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'isCompleted': isCompleted,
      'isImportant': isImportant,
      'categoryId': categoryId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'isImportant': isImportant,
      'categoryId': categoryId,
    };
  }

  factory TaskModel.fromEntity(TaskEntity task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      isCompleted: task.isCompleted,
      isImportant: task.isImportant,
      categoryId: task.categoryId,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    bool? isImportant,
    String? categoryId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      isImportant: isImportant ?? this.isImportant,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
