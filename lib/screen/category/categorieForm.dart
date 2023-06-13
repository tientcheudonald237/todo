import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class CategorieForm extends StatefulWidget {
  const CategorieForm({super.key});

  @override
  State<CategorieForm> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<CategorieForm> {
  Color mainColor = Color.fromARGB(255, 0, 0, 0);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? _selectedLanguage;

  Future Valide() async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('category');
      await usersRef.doc().set({
        'description': descriptionController.text.trim(),
        'name': nomController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'nouveau post ajouter',
            style: TextStyle(color: Colors.amber),
          ),
          backgroundColor: Colors.blue,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('error failed : $e');
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
                  height: 180,
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
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your surname';
                      }
                      return null;
                    },
                  ),
                ),
                Container(

                  height: 50,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                  
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                        height: 50,
                        minWidth: 380,
                        color: Colors.blue,
                        child: Text('Valider'),
                        onPressed: () {
                          Valide();
                        }),
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
