import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/projetService.dart';
import 'package:todo/provider/projetProvider.dart';
import 'addProjet.dart';

class Projet extends ConsumerWidget {
  const Projet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projetData = ref.watch(fetchStreamProvider);
    ProjetService projetService = ProjetService();

    if (projetData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: projetData.value?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final projet = projetData.value?[index];

          final id = projet?.id;
          final name = projet?.nom;
          final description = projet?.description;

          return Dismissible(
            key: Key(id!),
            background: Container(
              color: Colors.amber,
            ),
            onDismissed: (direction) {
              projetService.deleteProjet(id);
            },
            child: GestureDetector(
              onTap: () async {
                final newNameController = TextEditingController(text: name);
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
                          onPressed: () {
                            final newName = newNameController.text.trim();
                            final newDescription =
                                newDescriptionController.text.trim();
                            if (newName.isEmpty || newDescription.isEmpty) {
                              return;
                            }
                            projetService.updateProjet(id, newName, newDescription);
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
                  title: Text(name!),
                  subtitle: Text(description!),
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
