import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/projetService.dart';

class AddProjet extends ConsumerWidget {
  const AddProjet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nomController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    ProjetService projetService = ProjetService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  projetService.addProjet(
                      nomController.text, descriptionController.text);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
