import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trogo_mobile/providers/auth_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final AuthController _authController = AuthController(FirebaseAuth.instance);

  Future<void> _logout() async {
    await _authController.logOut();
    setState(() {
      currentUser = null; // Update the current user state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/equipment');
            },
            child: Text('Gérer mon équipement'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/workouts');
            },
            child: Text('Voir tous les entrainements'),
          ),
          Builder(builder: (context) {
            if (currentUser == null) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Se connecter"),
              );
            }
            return ElevatedButton(
              onPressed: _logout,
              child: Text('Se déconnecter'),
            );
          }),
        ],
      )),
    );
  }
}
