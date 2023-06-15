import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/model/User.dart';


final userProvider = Provider<User>(
  (ref) {
    return User(uid: "", email: '', nom: '', prenom: '', pathphoto: '');
  },
);

