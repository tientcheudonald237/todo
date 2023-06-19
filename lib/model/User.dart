import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserState {
  final String uid;
  final String email;
  final String nom;
  final String prenom;
  final String pathPhoto;

  UserState({
    required this.uid,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.pathPhoto,
  });

   static UserState fromJson(Map<String, dynamic> json) {
    return UserState(
      uid: json['uid'],
      email:json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      pathPhoto: json['pathphoto']
    );
  }

   Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nom': nom,
      'email': email,
      'prenom':prenom,
      'pathphoto':pathPhoto,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      uid: map['uid'],
      email:map['email'] as String,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      pathPhoto: map['pathphoto']as String,
    );
  }

  factory UserState.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserState(
      uid: doc['uid'],
      email:doc['email'],
      nom: doc['nom'],
      prenom: doc['prenom'],
      pathPhoto: doc['pathphoto']
    );
  }
}

class User extends StateNotifier<UserState> {
  User(
      {required String email,
      required String nom,
      required String pathphoto,
      required String prenom,
      required String uid})
      : super(
            UserState(uid: '', email: '', nom: '', prenom: '', pathPhoto: ''));

  void update({
    required String uid,
    required String email,
    required String nom,
    required String prenom,
    required String pathPhoto,
  }) {
    state = UserState(
      uid: uid,
      email: email,
      nom: nom,
      prenom: prenom,
      pathPhoto: pathPhoto,
    );
  }

  String get uid => state.uid;
  String get email => state.email;
  String get nom => state.nom;
  String get prenom => state.prenom;
  String get pathPhoto => state.pathPhoto;

  void updateUser({required String nom, required String prenom, String? pathPhoto}) {}
}
