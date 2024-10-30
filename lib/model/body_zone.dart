class BodyZone {
  final String name;

  BodyZone({required this.name});

  factory BodyZone.fromMap(Map<String, dynamic> data) {
    return BodyZone(
      name: data['name'] ?? '',
    );
  }
}
