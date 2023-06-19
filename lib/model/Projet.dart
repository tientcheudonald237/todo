import 'package:cloud_firestore/cloud_firestore.dart';

class Projet {
  late String id;
  late String nom;
  late String description;

  Projet({
    required this.id,
    required this.nom,
    required this.description,
  });

  static Projet fromJson(Map<String, dynamic> json) {
    return Projet(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }

   Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nom': nom,
      'description': description,
    };
  }

  factory Projet.fromMap(Map<String, dynamic> map) {
    return Projet(
      id: map['id'],
      nom: map['nom'] as String,
      description: map['description'] as String,
    );
  }

  factory Projet.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Projet(
      id: doc.id,
      nom: doc['nom'],
      description: doc['description'],
    );
  }
}
