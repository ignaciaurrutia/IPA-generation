class HealthInstitution {
  final String name;

  HealthInstitution({required this.name});

  factory HealthInstitution.fromJson(Map<String, dynamic> json) {
    return HealthInstitution(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}