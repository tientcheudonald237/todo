import 'package:cloud_firestore/cloud_firestore.dart';


class Category {
  late String id;
  late String nom;
  late String description;

  Category({
    required this.id,
    required this.nom,
    required this.description,
  });
  
  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }

  static Category fromJsonf(Map<String, dynamic> json) {
    return Category(
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

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      nom: map['nom'] as String,
      description: map['description'] as String,
    );
  }

  factory Category.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Category(
      id: doc.id,
      nom: doc['nom'],
      description: doc['description'],
    );
  }

}
