import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjetNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ProjetNotifier() : super([]);

  Future<void> getProjets() async {
    final snapshot = await FirebaseFirestore.instance.collection('projet').get();
    List<Map<String, dynamic>> categories = [];
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final name = doc['nom'] as String?;
        final description = doc['description'] as String?;
        if (name != null && description != null) {
          categories.add({'id': doc.id, 'nom': name, 'description': description});
        }
      }
    }
    state = categories;
  }

  Future<void> addProjet(String name, String description) async {
    final docRef = await FirebaseFirestore.instance.collection('projet').add({
      'nom': name,
      'description': description,
    });
    state = [...state, {'id': docRef.id, 'nom': name, 'description': description}];
  }

  Future<void> updateProjet(String id, String name, String description) async {
    await FirebaseFirestore.instance.collection('projet').doc(id).update({'nom': name, 'description': description});

    final index = state.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      state[index]['nom'] = name;
      state[index]['description'] = description;
    }
  }

  Future<void> deleteprojet(String id) async {
    await FirebaseFirestore.instance.collection('projet').doc(id).delete();

    state = state.where((element) => element['id'] != id).toList();
  }
}