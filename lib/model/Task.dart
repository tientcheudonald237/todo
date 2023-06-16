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
        userid: json['userid'],
        datedebut: json['datedebut'],
        datefin: json['datefin'],
        nom: json['nom'],
        picture: json['picture'],
        projet: json['projet'],
        statut: json['statut'],
        description: json['description'],
        otheruserid: json['otheruserid'],
        category: json['category']);
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
        userid: map['userid'] as String,
        datedebut: map['datedebut'] as String,
        datefin: map['datefin'] as String,
        nom: map['nom'] as String,
        picture: map['picture'] as String,
        projet: map['projet'] as String,
        statut: map['statut'] as String,
        description: map['description'] as String,
        otheruserid: map['otheruserid'] as String,
        category: map['category'] as String);
  }

  factory Task.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Task(
        id: doc.id,
        userid: doc['userid'],
        datedebut: doc['datedebut'],
        datefin: doc['datefin'],
        nom: doc['nom'],
        picture: doc['picture'],
        projet: doc['projet'],
        statut: doc['statut'],
        description: doc['description'],
        otheruserid: doc['otheruserid'],
        category: doc['category']);
  }
}
