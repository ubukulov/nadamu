class Vacancy {
  late final String name;
  late final String description;

  Vacancy({required this.name, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory Vacancy.fromJson(Map<String, dynamic> json) {
    return Vacancy(
      name: json['name'],
      description: json['description'],
    );
  }
}