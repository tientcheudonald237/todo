class Projet{
  late String nom;
  late String description ;
  

  Projet({
    required this.nom,
    required this.description,
  });

  static Projet fromJson(Map<String, dynamic> json) {
    return Projet(
      nom: json['nom'],
      description: json['description'],
    );
  }
}