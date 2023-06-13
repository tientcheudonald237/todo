class Category {
  late String nom;
  late String description;

  Category({
    required this.nom,
    required this.description,
  });

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      nom: json['name'],
      description: json['description'],
    );
  }
}
