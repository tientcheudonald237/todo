import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/Task.dart';

class TaskService {
  final todoCollection = FirebaseFirestore.instance.collection('task');

  void addTask(
      String id,
      String userid,
      String datedebut,
      String datefin,
      String nom,
      String picture,
      String projet,
      String statut,
      String description,
      String otheruserid,
      String category) {
    Task model = new Task(
        id: id,
        userid: userid,
        datedebut: datedebut,
        datefin: datefin,
        nom: nom,
        picture: picture,
        projet: projet,
        statut: statut,
        description: description,
        otheruserid: otheruserid,
        category: category);
    todoCollection.add(model.toMap());
  }

  void deleteTask(String? docID) {
    todoCollection.doc(docID).delete();
  }

  void updateTask(String id, String datefin, String nom, String statut,
      String description) {
    todoCollection.doc(id).update({
      'nom': nom,
      'description': description,
      'datefin': datefin,
      'statut': statut
    });
  }
}
