import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/model/Task.dart';
import 'package:todo/services/taskService.dart';

final serviceProvider = StateProvider<TaskService>((ref) {
  return TaskService();
});

final fetchStreamProvider = StreamProvider<List<Task>>((ref) async* {
  final getData = FirebaseFirestore.instance.collection('task').snapshots().map(
      (event) =>
          event.docs.map((snapshot) => Task.fromSnapshot(snapshot)).toList());
  yield* getData;
});
