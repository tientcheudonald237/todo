import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/Category.dart';

class CategoryService {
  final todoCollection = FirebaseFirestore.instance.collection('category');

  // CREATE TODO

  void addCategory(String nom, String description) {
    Category model = new Category(id: '', nom: nom, description: description);
    todoCollection.add(model.toMap());
  }

  //Delete
  void deleteCategory(String? docID) {
    todoCollection.doc(docID).delete();
  }

  void updateCategory(String id, String description, String nom) {
    Category model = new Category(id: id, nom: nom, description: description);
    todoCollection
        .doc(model.id)
        .update({'nom': nom, 'description': description});
  }
}
