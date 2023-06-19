import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/Projet.dart';

class ProjetService {
  final todoCollection = FirebaseFirestore.instance.collection('projet');

  // CREATE TODO

  // void addProjet(String nom, String description) {
  //   Projet model = new Projet(id: '', nom: nom, description: description);
  //   todoCollection.add(model.toMap());
  // }

  void addProjet(String nom, String description) async {
    Projet model = Projet(id: '', nom: nom, description: description);
    DocumentReference docRef = await todoCollection.add(model.toMap());
    // Mettre à jour le champ "id" avec l'ID généré par Firebase
    await docRef.update({"id": docRef.id});
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
