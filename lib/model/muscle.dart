class Muscle {
  final String name;

  Muscle({required this.name});

  factory Muscle.fromMap(Map<String, dynamic> data) {
    return Muscle(
      name: data['name'] ?? '',
    );
  }
}
