import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'categorieForm.dart';

class Categorie extends StatefulWidget {
  const Categorie({Key? key}) : super(key: key);

  @override
  _CategorieState createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  late List<Map<String, dynamic>> listHashtags;

  @override
  void initState() {
    super.initState();
    listHashtags = [];
    _getCategories();
  }

  Future<void> _getCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('category').get();
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final name = doc['name'] as String?;
        final description = doc['description'] as String?;
        if (name != null && description != null) {
          listHashtags.add({
            'id': doc.id,
            'name': name,
            'description': description
          });
        }
      }
    }
    setState(() {});
  }

  Future<void> _updateCategory(
      String id, String name, String description) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(id)
        .update({'name': name, 'description': description});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listHashtags.isEmpty
          ? const Center(
              child: Text('Aucune Liste'),
            )
          : ListView.builder(
              itemCount: listHashtags.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(listHashtags[index]['id']),
                  background: Container(
                    color: Colors.amber,
                  ),
                  onDismissed: (direction) async {
                    final id = listHashtags[index]['id'];
                    setState(() {
                      listHashtags.removeAt(index);
                    });
                    await FirebaseFirestore.instance
                        .collection('category')
                        .doc(id)
                        .delete();
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final newNameController = TextEditingController(
                          text: listHashtags[index]['name']);
                      final newDescriptionController = TextEditingController(
                          text: listHashtags[index]['description']);
showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Modifier la categorie'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: newNameController,
                                    decoration:
                                        InputDecoration(labelText: 'Nom'),
                                  ),
                                  TextField(
                                    controller: newDescriptionController,
                                    decoration: InputDecoration(
                                        labelText: 'Description'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final newName =
                                        newNameController.text.trim();
                                    final newDescription =
                                        newDescriptionController.text.trim();
                                    if (newName.isEmpty ||
                                        newDescription.isEmpty) {
                                      return;
                                    }
                                    final id = listHashtags[index]['id'];
                                    await _updateCategory(
                                        id, newName, newDescription);
                                    setState(() {
                                      listHashtags[index]['name'] = newName;
                                      listHashtags[index]['description'] =
                                          newDescription;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Sauvegarder'),
                                ),
                              ],
                            );
                          });
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(listHashtags[index]['name']),
                        subtitle: Text(listHashtags[index]['description']),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategorieForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}