import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/categoryService.dart';

class CategorieForm extends ConsumerWidget {
  const CategorieForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nomController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    CategoryService categoryService = new CategoryService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
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
                  height: 180,
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
                        return 'Please enter your name';
                      }
                      return null;
                    },
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
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your surname';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 50,
                  color: Color.fromARGB(240, 48, 48, 48),
                  child: Center(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                        height: 50,
                        minWidth: 200,
                        color: Colors.blue,
                        child: Text('Valider'),
                        onPressed: () {
                          categoryService.addCategory(nomController.text.trim(),
                              descriptionController.text.trim());
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
