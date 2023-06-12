import 'package:flutter_riverpod/flutter_riverpod.dart';

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
