import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/screen/tache/TaskForm.dart';
import 'package:todo/services/riverpod.dart';
import 'package:todo/services/taskService.dart';
import 'package:todo/provider/TaskProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends ConsumerWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskData = ref.watch(fetchStreamProvider);
    TaskService taskService = TaskService();

    String? _statut;

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

    if (taskData == null) {
      return Center(child: CircularProgressIndicator());
    }

    final user = ref.read(userProvider);

    return Scaffold(
      body: ListView.builder(
        // itemCount: taskData.value?.length ?? 0,
        itemCount: taskData.value
                ?.where((task) =>
                    task?.userid == user.uid || task?.otheruserid == user.uid)
                .length ??
            0,

        itemBuilder: (context, index) {
          // final task = taskData.value?[index];
          final task = taskData.value
              ?.where((task) =>
                  task?.userid == user.uid || task?.otheruserid == user.uid)
              .toList()[index];

          Color backgroundColor;
          final statut = task!.statut;

          if (statut == 'encours') {
            backgroundColor = Colors.green;
          } else if (statut == 'fait') {
            backgroundColor = Colors.red;
          } else {
            backgroundColor = Colors.blue;
          }

          return Dismissible(
            key: Key(index.toString()),
            background: Container(
              color: backgroundColor,
            ),
            onDismissed: (direction) {
              try {
                taskService.deleteTask(task.id);
              } catch (e) {
                // Gérez toute erreur éventuelle ici
                print('Erreur lors de la suppression de la tâche : $e');
              }
            },
            child: Column(
              children: [
                SizedBox(height: 5),
                Card(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text('🔊' + task!.category + ' 👉 ' + task!.nom),
                    subtitle: Text(
                      '⏰' + task!.datefin + ' 🥌 ' + task!.projet,
                      style: TextStyle(fontSize: 12.0, color: Colors.amber),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(task!.picture),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            String nom = task!.nom;
                            String description = task!.description;
                            String datefin = task!.datefin;
                            String othernomuser = '';
                            final userCollection =
                                FirebaseFirestore.instance.collection('user');

                            return FutureBuilder<DocumentSnapshot>(
                                future:
                                    userCollection.doc(task!.otheruserid).get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    final data = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                    othernomuser = data['nom'];
                                  } else {
                                    othernomuser = '';
                                  }
                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(height: 8),
                                          TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Nom',
                                            ),
                                            onChanged: (value) {
                                              nom = value;
                                            },
                                            controller: TextEditingController(
                                                text: nom),
                                          ),
                                          SizedBox(height: 8),
                                          TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Description',
                                            ),
                                            onChanged: (value) {
                                              description = value;
                                            },
                                            controller: TextEditingController(
                                                text: description),
                                          ),
                                          SizedBox(height: 8),
                                          DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              labelText: "Statut",
                                            ),
                                            value: task.statut,
                                            onChanged: (newValue) {
                                              _statut = newValue;
                                            },
                                            items: [
                                              DropdownMenuItem(
                                                value: 'attente',
                                                child: Text('En attente'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'encours',
                                                child: Text('En cours'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'fait',
                                                child: Text('Fait'),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Date de fin',
                                            ),
                                            onChanged: (value) {
                                              datefin = value;
                                            },
                                            controller: TextEditingController(
                                                text: datefin),
                                          ),
                                          SizedBox(height: 8),
                                          TextField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                labelText: 'Colaborateur',
                                              ),
                                              controller: TextEditingController(
                                                text: othernomuser,
                                              )),
                                          SizedBox(height: 8),
                                          TextField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                              labelText: 'Date de debut',
                                            ),
                                            controller: TextEditingController(
                                                text: task.datedebut),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  taskService.updateTask(
                                                      task.id,
                                                      datefin,
                                                      nom,
                                                      _statut!,
                                                      description);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Valider'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        );
                      },
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  value: calculatePercentage(task!.datedebut, task!.datefin,
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
