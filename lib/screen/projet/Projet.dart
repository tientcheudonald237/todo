import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'addProjet.dart';

class Projet extends StatefulWidget {
  const Projet({Key? key}) : super(key: key);

  @override
  _ProjetState createState() => _ProjetState();
}

class _ProjetState extends State<Projet> {
  late List<Map<String, dynamic>> listHashtags;

  @override
  void initState() {
    super.initState();
    listHashtags = [];
    _getProjets();
  }

  Future<void> _getProjets() async {
    final snapshot = await FirebaseFirestore.instance.collection('projet').get();
    if (!mounted) return; // Vérifier si le widget est toujours monté
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final nom = doc['nom'] as String?;
        final description = doc['description'] as String?;
        if (nom != null && description != null) {
          listHashtags.add({'id': doc.id, 'nom': nom, 'description': description});
        }
      }
    }
    if (mounted) { // Vérifier encore une fois si le widget est toujours monté
      setState(() {});
    }
  }

Future<void> _updateCategory(String id, String name, String description) async {
    await FirebaseFirestore.instance.collection('projet').doc(id).update({'nom': name, 'description': description});
    if (!mounted) return;
    setState(() {});
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
                        .collection('projet')
                        .doc(id)
                        .delete();
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final newNameController = TextEditingController(
                          text: listHashtags[index]['nom']);
                      final newDescriptionController = TextEditingController(
                          text: listHashtags[index]['description']);
showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Modifier le Projet'),
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
                                      listHashtags[index]['nom'] = newName;
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
                        title: Text(listHashtags[index]['nom']),
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
                  builder: (context) => const AddProjet()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}