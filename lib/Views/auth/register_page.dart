// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/providers/auth_controller.dart';

class RegisterPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            TextField(
              controller: repasswordController,
              decoration: InputDecoration(labelText: 'Confirmer le Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                String secondpassword = repasswordController.text.trim();

                User? user = await authController.register(email, password);

                if (user != null) {
                  if(secondpassword != password) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Les mots de passe doivent être identiques.")),
                    ); 
                  } else {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Échec de l'inscription. Veuillez réessayer.")),
                  );
                }
              },
              child: Text("S'inscrire"),
            ),
            ElevatedButton(
              onPressed: () async {
              Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}