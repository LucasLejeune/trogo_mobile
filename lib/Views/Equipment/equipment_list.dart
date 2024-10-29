import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trogo_mobile/model/equipment.dart';

class EquipmentListScreen extends StatefulWidget {
  @override
  _EquipmentListScreenState createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  List<Equipment> _items = [];
  List<bool> _selectedItems = [];

  Future<List<Equipment>> fetchItems() async {
    List<Equipment> items = [];
    QuerySnapshot equipmentSnapshot =
        await FirebaseFirestore.instance.collection('Equipments').get();
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc('jFOaMexbbC8Y32NcK92I');
    //TODO: remplacer par l'utilisateur connecté.
    //TODO: utiliser un hook
    DocumentSnapshot documentSnapshot = await userDoc.get();
    Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> userEquipments = userData['Equipments'];
    if (_selectedItems.isEmpty) {
      _selectedItems = List<bool>.filled(equipmentSnapshot.docs.length, false);
    }
    equipmentSnapshot.docs.asMap().forEach((index, doc) {
      String name = doc['name'];
      if (userEquipments.contains(name)) {
        _selectedItems[index] = true;
      }
      items.add(Equipment(name: name));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer l'équipement"),
      ),
      body: FutureBuilder<List<Equipment>>(
        future: fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found.'));
          } else {
            _items = snapshot.data!;
            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_items[index].name),
                  value: _selectedItems[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedItems[index] = value ?? true;
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
