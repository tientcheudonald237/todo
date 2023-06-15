import 'package:flutter/material.dart';
import 'package:todo/model/User.dart';
import 'package:todo/screen/authentification/signup.dart';
import 'package:todo/screen/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future signIn() async {
      try {
        // -------------------------------------------------------------------------

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        // -------------------------------------------------------------------------

        final firebaseStorage = FirebaseStorage.instance;
        final userRef = FirebaseFirestore.instance.collection('user');

        final querySnapshot = await userRef
            .where('email', isEqualTo: emailController.text.trim())
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userDoc = querySnapshot.docs.first;
          final nom = userDoc.get('nom');
          final prenom = userDoc.get('prenom');
          final uid = userDoc.get('uid');
          final pathPhoto = userDoc.get('pathphoto');

          ref.read(userProvider).update(
              uid: uid,
              email: emailController.text.trim(),
              nom: nom,
              prenom: prenom,
              pathPhoto: pathPhoto);

          // print(pathPhoto);
          // print(nom);
          // print(prenom);
          // print(uid);
        } else {
          print('No user found with email ');
        }

        // -------------------------------------------------------------------------

        // -------------------------------------------------------------------------
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePages()),
        );
      } on FirebaseAuthException catch (e) {
        print('Error : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'erreur de  connexion verifier vos informations',
              style: TextStyle(color: Colors.amber),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to Todolist',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        signIn();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      "Don't have account? Sign Up here",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
