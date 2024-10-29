import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trogo_mobile/Logics/Equipment/equipment_service.dart';
import 'package:trogo_mobile/Logics/Equipment/selected_equipment_notifier.dart';
import 'package:trogo_mobile/model/equipment.dart';
import 'dart:developer';

class EquipmentListScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentAsyncValue = ref.watch(equipmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer l'équipement"),
      ),
      body: equipmentAsyncValue.when(
        data: (items) {
          final userEquipments = useState<List<String>>([]);

          final selectedItems = ref.watch(selectedItemsProvider(items.length));

          final equipmentServiceProvider =
              Provider((ref) => EquipmentService());

          useEffect(() {
            userEquipments.value = [];
            return null;
          }, []);

          return Column(children: [
            Expanded(
                child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(items[index].name),
                  value: selectedItems[index],
                  onChanged: (bool? value) {
                    ref
                        .read(selectedItemsProvider(items.length).notifier)
                        .toggleSelection(index, items[index].name);
                  },
                );
              },
            )),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(equipmentServiceProvider)
                    .addEquipment(items, selectedItems);
              },
              child: Text("Mettre à jour l'équipement"),
            )
          ]);
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
