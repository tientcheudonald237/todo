import 'package:flutter/material.dart';
import 'package:todo/notifier/ProjetNotifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/riverpod.dart';
import 'package:todo/notifier/ProjetNotifier.dart';

import 'addProjet.dart';

class Projet extends ConsumerWidget {
  const Projet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(projetProvider.notifier).getProjets();

    final projetState = ref.watch(projetProvider.notifier);
    final listHashtags = projetState.state;

    

    return Scaffold(
      body: listHashtags.isEmpty
          ? const Center(
              child: Text('Aucune Liste'),
            )
          : ListView.builder(
              itemCount: listHashtags.length,
              itemBuilder: (context, index) {
                final id = listHashtags[index]['id'];
                final name = listHashtags[index]['nom'];
                final description = listHashtags[index]['description'];

                return Dismissible(
                  key: Key(id),
                  background: Container(
                    color: Colors.amber,
                  ),
                  onDismissed: (direction) async {
                    await ref.read(projetProvider.notifier).deleteprojet(id);
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final newNameController =
                          TextEditingController(text: name);
                      final newDescriptionController =
                          TextEditingController(text: description);

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
                                  decoration: InputDecoration(labelText: 'Nom'),
                                ),
                                TextField(
                                  controller: newDescriptionController,
                                  decoration:
                                      InputDecoration(labelText: 'Description'),
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
                                  final newName = newNameController.text.trim();
                                  final newDescription =
                                      newDescriptionController.text.trim();
                                  if (newName.isEmpty ||
                                      newDescription.isEmpty) {
                                    return;
                                  }
                                  await ref
                                      .read(projetProvider.notifier)
                                      .updateProjet(
                                          id, newName, newDescription);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Sauvegarder'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(description),
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
            MaterialPageRoute(builder: (context) => const AddProjet()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
