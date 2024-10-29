import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trogo_mobile/providers/crud_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Utilisateurs')),
      body: user.when(
        data: (data) {
          return ListView(
            children: data.docs.map((document) {
              final user = document.data();
              return ListTile(
                title: Text(user['nom']),
                subtitle: Text(user['email']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(userServiceProvider).deleteUser(document.id);
                  },
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(userServiceProvider).addUser("Nouveau", "nouveau@mail.com");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}