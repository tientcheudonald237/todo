import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/categoryService.dart';
import 'package:todo/provider/categoryprovider.dart';
import 'categorieForm.dart';

class Categorie extends ConsumerWidget {
  const Categorie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryData = ref.watch(fetchStreamProvider);
    CategoryService categoryService = CategoryService();

    if (categoryData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: categoryData.value?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final category = categoryData.value?[index];

          final id = category?.id;
          final name = category?.nom;
          final description = category?.description;

          return Dismissible(
            key: Key(id!),
            background: Container(
              color: Colors.amber,
            ),
            onDismissed: (direction) {
              categoryService.deleteCategory(id);
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
                        title: Text('Modifier la categorie'),
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
                              if (newName.isEmpty || newDescription.isEmpty) {
                                return;
                              }

                              categoryService.updateCategory(
                                  id, newName, newDescription);

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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CategorieForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
