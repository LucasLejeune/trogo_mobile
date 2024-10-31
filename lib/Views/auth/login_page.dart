// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trogo_mobile/providers/auth_controller.dart';

class LoginPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) => email = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  onChanged: (value) => password = value,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    User? user = await authController.logIn(email, password);
                    if (user != null) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                  child: const Text('Se connecter'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text("S'inscrire"),
                ),
              ],
            )),
      ),
    );
  }
}
