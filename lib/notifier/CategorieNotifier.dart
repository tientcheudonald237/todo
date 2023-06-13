import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorieNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CategorieNotifier() : super([]);

  Future<void> getCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('category').get();
    List<Map<String, dynamic>> categories = [];
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final name = doc['name'] as String?;
        final description = doc['description'] as String?;
        if (name != null && description != null) {
          categories.add({'id': doc.id, 'name': name, 'description': description});
        }
      }
    }
    state = categories;
  }

  Future<void> addCategory(String name, String description) async {
    final docRef = await FirebaseFirestore.instance.collection('category').add({
      'name': name,
      'description': description,
    });
    state = [...state, {'id': docRef.id, 'name': name, 'description': description}];
  }

  Future<void> updateCategory(String id, String name, String description) async {
    await FirebaseFirestore.instance.collection('category').doc(id).update({'name': name, 'description': description});

    final index = state.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      state[index]['name'] = name;
      state[index]['description'] = description;
    }
  }

  Future<void> deleteCategory(String id) async {
    await FirebaseFirestore.instance.collection('category').doc(id).delete();

    state = state.where((element) => element['id'] != id).toList();
  }
}