import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late String id;
  late String userid;
  late String datedebut;
  late String datefin;
  late String nom;
  late String picture;
  late String projet;
  late String statut;
  late String description;
  late String otheruserid;
  late String category;

  Task({
    required this.id,
    required this.userid,
    required this.datedebut,
    required this.datefin,
    required this.nom,
    required this.picture,
    required this.projet,
    required this.statut,
    required this.description,
    required this.otheruserid,
    required this.category,
  });

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        userid: json['id'],
        datedebut: json[''],
        datefin: json[''],
        nom: json[''],
        picture: json[''],
        projet: json[''],
        statut: json[''],
        description: json[''],
        otheruserid: json[''],
        category: json['']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nom': nom,
      'description': description,
      'userid': userid,
      'datedebut': datedebut,
      'datefin': datefin,
      'picture': picture,
      'projet': projet,
      'statut': statut,
      'otheruserid': otheruserid,
      'category': category
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        userid: map['id'] as String,
        datedebut: map[''] as String,
        datefin: map[''] as String,
        nom: map[''] as String,
        picture: map[''] as String,
        projet: map[''] as String,
        statut: map[''] as String,
        description: map[''] as String,
        otheruserid: map[''] as String,
        category: map[''] as String);
  }

  factory Task.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Task(
        id: doc.id,
        userid: doc['id'],
        datedebut: doc[''],
        datefin: doc[''],
        nom: doc[''],
        picture: doc[''],
        projet: doc[''],
        statut: doc[''],
        description: doc[''],
        otheruserid: doc[''],
        category: doc['']);
  }
}
