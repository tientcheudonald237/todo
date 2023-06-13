import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/model/User.dart';
import 'package:todo/notifier/CategorieNotifier.dart';
import 'package:todo/notifier/ProjetNotifier.dart';


final userProvider = Provider<User>(
  (ref) {
    return User(uid: "", email: '', nom: '', prenom: '', pathphoto: '');
  },
);

final categorieProvider = StateNotifierProvider((ref) => CategorieNotifier());


final projetProvider = StateNotifierProvider((ref) => ProjetNotifier());
