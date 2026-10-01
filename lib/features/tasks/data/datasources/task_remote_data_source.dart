import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSource({
    required this.firestore,
  });

  // Get all tasks
  Future<List<TaskModel>> getTasks() async {
    final snapshot = await firestore
        .collection('tasks')
        .get();

    return snapshot.docs
        .map((doc) => TaskModel.fromFirestore(doc))
        .toList();
  }

  // Add task
  Future<TaskModel> addTask(TaskModel task) async {
    final docRef = firestore
        .collection('tasks')
        .doc(task.id);

    await docRef.set(
      task.toFirestore(),
    );

    return TaskModel(
      id: docRef.id,
      title: task.title,
      description: task.description,
      date: task.date,
      isCompleted: task.isCompleted,
      isImportant: task.isImportant,
      categoryId: task.categoryId,
    );
  }

  // Update task
  Future<TaskModel> updateTask(TaskModel task) async {
    final docRef = firestore
        .collection('tasks')
        .doc(task.id);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Task not found');
    }

    await docRef.update(
      task.toFirestore(),
    );

    return task;
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    final docRef = firestore
        .collection('tasks')
        .doc(id);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Task not found');
    }

    await docRef.delete();
  }

  // Complete / Uncomplete task
  Future<TaskModel> completeTask({
    required String id,
    required bool isCompleted,
  }) async {
    final docRef = firestore
        .collection('tasks')
        .doc(id);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Task not found');
    }

    await docRef.update({
      'isCompleted': isCompleted,
    });

    final updatedSnapshot = await docRef.get();

    return TaskModel.fromFirestore(
      updatedSnapshot,
    );
  }
}