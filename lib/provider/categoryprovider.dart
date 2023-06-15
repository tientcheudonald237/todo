import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/model/Projet.dart';
import 'package:todo/services/projetService.dart';

final serviceProvider = StateProvider<ProjetService>((ref) {
  return ProjetService();
});

final fetchStreamProvider = StreamProvider<List<Projet>>((ref) async* {
  final getData = FirebaseFirestore.instance
      .collection('category')
      .snapshots()
      .map((event) =>
          event.docs.map((snapshot) => Projet.fromSnapshot(snapshot)).toList());
  yield* getData;
});
