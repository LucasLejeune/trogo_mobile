import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trogo_mobile/providers/auth_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.currentIndex});
  final int currentIndex;
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
      currentUser = null;
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/equipment');
        break;
      case 2:
        Navigator.pushNamed(context, '/login');
        break;
    }
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Equipement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Authentification',
          ),
        ],
      ),
    );
  }
}
