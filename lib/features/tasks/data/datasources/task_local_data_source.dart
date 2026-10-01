import '../models/task_model.dart';

class TaskLocalDataSource {
  final List<TaskModel> _tasks = [];

  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return List<TaskModel>.from(_tasks);
  }

  Future<TaskModel> addTask(TaskModel task) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    _tasks.add(task);

    return task;
  }

  Future<TaskModel> completeTask({
  required String id,
  required bool isCompleted,
}) async {
  await Future.delayed(
    const Duration(milliseconds: 300),
  );

  final index = _tasks.indexWhere(
    (item) => item.id == id,
  );

  if (index == -1) {
    throw Exception('Task not found');
  }

  final updatedTask = _tasks[index].copyWith(
    isCompleted: isCompleted,
  );

  _tasks[index] = updatedTask;

  return updatedTask;
}


  Future<TaskModel> updateTask(TaskModel task) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final index = _tasks.indexWhere(
      (item) => item.id == task.id,
    );

    if (index == -1) {
      throw Exception('Task not found');
    }

    _tasks[index] = task;

    return task;
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final index = _tasks.indexWhere(
      (item) => item.id == id,
    );

    if (index == -1) {
      throw Exception('Task not found');
    }

    _tasks.removeAt(index);
  }
}