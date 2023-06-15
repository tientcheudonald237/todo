import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Projet {
  final String nom;
  final String description;
  final String id;

  Projet(this.nom, this.description, this.id);
}

final projetProvider = StateNotifierProvider<ProjetNotifier, List<Projet>>(
  (ref) => ProjetNotifier(),
);

class ProjetNotifier extends StateNotifier<List<Projet>> {
  // Référence à la collection Firestore pour les projets
  final CollectionReference _projetCollection =
      FirebaseFirestore.instance.collection('projet');

  ProjetNotifier() : super([]);

  /// Récupérer la liste des projets depuis Firestore
  Stream<List<Projet>> getProjets() =>
      _projetCollection.snapshots().map((snapshot) {
        final projets = <Projet>[];
        for (final doc in snapshot.docs) {
          projets.add(Projet(doc.get('nom') as String,
              doc.get('description') as String, doc.id));
        }
        return projets;
      });

  /// Ajouter un nouveau projet dans Firestore avec le nom et la description donnés
  Future<void> addProjet(String nom, String description) async {
    await _projetCollection.add({
      'nom': nom,
      'description': description,
    });
  }

  /// Mettre à jour le projet avec le même ID dans Firestore avec les nouvelles valeurs données
  Future<void> updateProjet(Projet updatedProjet) async {
    await _projetCollection.doc(updatedProjet.id).update({
      'nom': updatedProjet.nom,
      'description': updatedProjet.description,
    });
  }

  /// Supprimer le projet donné de Firestore
  Future<void> deleteProjet(Projet projet) async {
    await _projetCollection.doc(projet.id).delete();
  }
}
