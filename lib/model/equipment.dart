import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  final String name;

  Equipment({required this.name});
}

final equipmentProvider = FutureProvider<List<Equipment>>((ref) async {
  return await fetchItems();
});

Future<List<Equipment>> fetchItems() async {
  List<Equipment> items = [];

  try {
    QuerySnapshot equipmentSnapshot =
        await FirebaseFirestore.instance.collection('Equipments').get();

    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc('jFOaMexbbC8Y32NcK92I');

    DocumentSnapshot documentSnapshot = await userDoc.get();
    Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;

    List<dynamic> userEquipments = userData['Equipments'] ?? [];

    for (var doc in equipmentSnapshot.docs) {
      items.add(Equipment(name: doc['name']));
    }
  } catch (e) {
    print('Error fetching items: $e');
    throw Exception('Failed to fetch items');
  }

  return items;
}
