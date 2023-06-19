import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/services/riverpod.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  Color mainColor = Color.fromARGB(255, 0, 0, 0);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  // String? _selectedLanguage;
  File? image;
  String? _imageUrl;

  Future<void> updateUser() async {
    try {
      // Récupérer l'ID de l'utilisateur courant
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not logged in')));
        return;
      }
      final userId = currentUser.uid;

      // Envoyer l'image sélectionnée à Firebase Storage
      String? pathPhoto;
      if (image != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('user').child(userId);
        final uploadTask = storageRef.putFile(image!);
        final taskSnapshot = await uploadTask.whenComplete(() {});
        pathPhoto = await taskSnapshot.ref.getDownloadURL();
      }

      // Mettre à jour les champs nom, prenom et pathPhoto dans Firestore
      final userRef = FirebaseFirestore.instance.collection('user').doc(userId);
      await userRef.update({
        'nom': nomController.text,
        'prenom': prenomController.text,
        'pathPhoto': pathPhoto,
      });

      // Enregistrer les modifications dans le StateProvider
      ref.read(userProvider).updateUser(
            nom: nomController.text,
            prenom: prenomController.text,
            pathPhoto: pathPhoto,
          );

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')));
    } catch (e) {
      print('Failed to update user: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to update user')));
    }
  }

  @override
  void initState() {
    super.initState();
    final User = ref.read(userProvider);
    setState(() {
      nomController.text = User.nom;
      prenomController.text = User.prenom;
      _imageUrl = User.pathPhoto;
    });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return null;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageG() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => pickImage(),
                    child: ClipOval(
                      child: _imageUrl != null
                          ? Image.network(
                              _imageUrl!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : const FlutterLogo(
                              size: 180,
                            ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: nomController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 25,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: prenomController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Surname"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your surname';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 25,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: MaterialButton(
                        minWidth: 300,
                        height: 50,
                        color: Colors.blue,
                        onPressed: () async => {await updateUser()},
                        child: const Text(
                          "Modifier",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
