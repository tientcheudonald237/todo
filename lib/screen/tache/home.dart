import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/screen/tache/TaskForm.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final List<Map<String, dynamic>> listHashtags = [];
  String? _statut;

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
          final datedebut = doc['datedebut'] as String?;
          final category = doc['categorie'] as String?;
          final projet = doc['projet'] as String?;

          if (name != null &&
              description != null &&
              imageUrl != null &&
              status != null &&
              datefin != null &&
              datedebut != null &&
              category != null &&
              projet != null) {
            listHashtags.add({
              'id': doc.id, // Ajout de l'identifiant du document
              'nom': name,
              'description': description,
              'picture': imageUrl,
              'statut': status,
              'datedebut': datedebut,
              'datefin': datefin,
              'projet': projet,
              'category': category,
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

  double calculatePercentage(
      String startStr, String endStr, String currentStr) {
    DateTime start = DateTime.parse(startStr);
    DateTime end = DateTime.parse(endStr);
    DateTime current = DateTime.parse(currentStr);

    if (current.isBefore(start)) {
      return 0; // Si la date actuelle est avant la date de début, renvoyer 0
    } else if (current.isAfter(end)) {
      return 1; // Si la date actuelle est après la date de fin, renvoyer 100
    } else {
      // Calculer le pourcentage à l'aide de la différence entre les dates
      final totalDuration = end.difference(start).inMilliseconds;
      final elapsedDuration = current.difference(start).inMilliseconds;
      final percent = (elapsedDuration / totalDuration);
      return percent;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return SizedBox.shrink();
    }
    return Scaffold(
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
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Card(
                        color: backgroundColor,
                        child: ListTile(
                          title: Text(listHashtags[index]['nom'] +
                              ' : ' +
                              listHashtags[index]['category']),
                          subtitle: Text(
                            listHashtags[index]['datefin'] +
                                ' : ' +
                                listHashtags[index]['projet'],
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.amber),
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
                                  String datefin =
                                      listHashtags[index]['datefin'];
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
                                        SizedBox(height: 3),
                                        DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Projet"),
                                          value: _statut,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _statut = newValue;
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem(
                                                value: 'attente',
                                                child: Text('En attente')),
                                            DropdownMenuItem(
                                                value: 'En cours',
                                                child: Text('En cours')),
                                          ],
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Date de fin'),
                                          onChanged: (value) {
                                            datefin = value;
                                          },
                                          controller: TextEditingController(
                                              text: datefin),
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
                                            'statut': _statut,
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
                      LinearProgressIndicator(
                        value: calculatePercentage(
                            listHashtags[index]['datedebut'],
                            listHashtags[index]['datefin'],
                            DateTime.now().toIso8601String().substring(0, 10)),
                        backgroundColor: Colors.white,
                        color: Color.fromARGB(255, 7, 63, 245),
                      ),
                      SizedBox(height: 5),
                    ],
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
