class Equipment {
  final String name;

  Equipment({required this.name});

  factory Equipment.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return Equipment(
      name: data['name'] ?? '',
    );
  }
}
