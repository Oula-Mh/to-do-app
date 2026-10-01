import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/tasks/data/datasources/task_remote_data_source.dart';
import '../../features/tasks/data/repositories/task_repository_impl.dart';

import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/domain/usecases/add_task.dart';
import '../../features/tasks/domain/usecases/complete_task.dart';
import '../../features/tasks/domain/usecases/delete_task.dart';
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/domain/usecases/update_task.dart';

import '../../features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================================
  // Firebase
  // ============================================================

  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // ============================================================
  // Data sources
  // ============================================================

  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSource(
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // ============================================================
  // Repository
  // ============================================================

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteDataSource: sl<TaskRemoteDataSource>(),
    ),
  );

  // ============================================================
  // Use cases
  // ============================================================

  sl.registerLazySingleton<GetTasks>(
    () => GetTasks(sl<TaskRepository>()),
  );

  sl.registerLazySingleton<AddTask>(
    () => AddTask(sl<TaskRepository>()),
  );

  sl.registerLazySingleton<UpdateTask>(
    () => UpdateTask(sl<TaskRepository>()),
  );

  sl.registerLazySingleton<DeleteTask>(
    () => DeleteTask(sl<TaskRepository>()),
  );

  sl.registerLazySingleton<CompleteTask>(
    () => CompleteTask(sl<TaskRepository>()),
  );

  // ============================================================
  // Bloc
  // ============================================================

  sl.registerFactory<TaskBloc>(
    () => TaskBloc(
      getTasks: sl<GetTasks>(),
      addTask: sl<AddTask>(),
      updateTask: sl<UpdateTask>(),
      deleteTask: sl<DeleteTask>(),
      completeTask: sl<CompleteTask>(),
    ),
  );
}