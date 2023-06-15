import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/Projet.dart';

class ProjetService {
  final todoCollection = FirebaseFirestore.instance.collection('projet');

  // CREATE TODO

  void addProjet(Projet model) {
    todoCollection.add(model.toMap());
  }

  //Delete
  void deleteProjet(String? docID) {
    todoCollection.doc(docID).delete();
  }

  void updateProjet(String id, String description, String nom) {
    Projet model = new Projet(id: id, nom: nom, description: description);
    todoCollection
        .doc(model.id)
        .update({'nom': nom, 'description': description});
  }
}
