import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/screen/TaskForm.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final List<Map<String, dynamic>> listHashtags = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('task').get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final name = doc['nom'] as String?;
          final description = doc['description'] as String?;
          final imageUrl = doc['picture'] as String?;
          final status = doc['statut'] as String?;
          final datefin = doc['datefin'] as String?;
          if (name != null &&
              description != null &&
              imageUrl != null &&
              status != null &&
              datefin != null) {
            listHashtags.add({
              'id': doc.id, // Ajout de l'identifiant du document
              'nom': name,
              'description': description,
              'picture': imageUrl,
              'statut': status,
              'datefin': datefin,
            });
          }
        }
        if (mounted) {
          // Vérification si le widget est toujours monté
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des taches'),
      ),
      body: listHashtags.isEmpty
          ? const Center(
              child: Text('Aucune Liste'),
            )
          : ListView.builder(
              itemCount: listHashtags.length,
              itemBuilder: (context, index) {
                final backgroundColor =
                    listHashtags[index]['statut'] == 'En cours'
                        ? Colors.green
                        : Colors.red;
                return Dismissible(
                  key: Key(index.toString()),
                  background: Container(
                    color: backgroundColor,
                  ),
                  child: Card(
                    color: backgroundColor,
                    child: ListTile(
                      title: Text(listHashtags[index]['nom'] +
                          ' : ' +
                          listHashtags[index]['description']),
                      subtitle: Text(
                        listHashtags[index]['datefin'],
                        style: TextStyle(
                            fontSize: 12.0, color: Colors.grey.shade600),
                      ),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(listHashtags[index]['picture']),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String nom = listHashtags[index]['nom'];
                              String description =
                                  listHashtags[index]['description'];
                              String datefin = listHashtags[index]['datefin'];
                              return AlertDialog(
                                title: Text('Modifier la tâche'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration:
                                          InputDecoration(labelText: 'Nom'),
                                      onChanged: (value) {
                                        nom = value;
                                      },
                                      controller:
                                          TextEditingController(text: nom),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          labelText: 'Description'),
                                      onChanged: (value) {
                                        description = value;
                                      },
                                      controller: TextEditingController(
                                          text: description),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          labelText: 'Date de fin'),
                                      onChanged: (value) {
                                        datefin = value;
                                      },
                                      controller:
                                          TextEditingController(text: datefin),
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
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('task')
                                          .doc(listHashtags[index][
                                              'id']) // Utilisation de l'identifiant du document
                                          .update({
                                        'nom': nom,
                                        'description': description,
                                        'datefin': datefin,
                                      }).then((value) {
                                        if (mounted) {
                                          // Vérification si le widget est toujours monté
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    },
                                    child: Text('Enregistrer'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TaskForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
