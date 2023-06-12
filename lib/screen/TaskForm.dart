import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({super.key});

  @override
  ConsumerState<TaskForm> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<TaskForm> {
  Color mainColor = Color.fromARGB(255, 0, 0, 0);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  String? _selectedLanguage;
  late String formattedDate;

  File? image;
  TextEditingController dateinput = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = [];

  Future PickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return null;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future PickImageG() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  final CollectionReference myCollection =
      FirebaseFirestore.instance.collection('task');

// Ajouter un document avec des champs
  Future<void> ajouterDocument() async {
    final user = ref.read(userProvider);
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('/profilePics/${image?.path.split('/').last}');
    final UploadTask uploadTask = storageReference.putFile(image!);
    final TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() => null);
    final String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    await myCollection
        .add({
          'nom': nomController.text.trim(),
          'description': prenomController.text.trim(),
          'statut': 'attente',
          'picture': downloadUrl,
          'userid': user.uid,
          'datefin': formattedDate,
          'categorie': _selectedCategory,
        })
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tache AJouter !'),
              ),
            ))
        .catchError(
            (error) => print("Erreur lors de l'ajout du document : $error"));
    nomController.text = '';
    prenomController.text = '';
  }

  Future<void> _loadCategories() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('category').get();
    if (snapshot.docs.isNotEmpty) {
      final List<String> categories =
          snapshot.docs.map((doc) => doc.get('name') as String).toList();
      setState(() {
        _categories.addAll(categories);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Task Form",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.5,
          ),
        ),
      ),
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
                  child: image != null
                      ? ClipOval(
                          child: Image.file(
                            image!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const FlutterLogo(
                          size: 160,
                        ),
                ),
                Container(
                  height: 20,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => {PickImage()},
                        child: const Text('Camera'),
                      ),
                      ElevatedButton(
                        onPressed: () => {PickImageG()},
                        child: const Text('Gallery'),
                      ),
                    ],
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
                    controller: nomController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: prenomController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Category"),
                    value: _selectedLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: "fr",
                        child: Text("travailler"),
                      ),
                      DropdownMenuItem(
                        value: "en",
                        child: Text("reposer"),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Date" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2023),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2077));

                    if (pickedDate != null) {
                      formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      setState(() {
                        dateinput.text = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
                Container(
                  height: 25,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => {
                      ajouterDocument(),
                    },
                    child: const Text(
                      "Valider",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
