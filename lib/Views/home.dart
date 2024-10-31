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
    if (currentUser == null) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/login');
          break;
      }
    } else {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/equipment');
          break;
        case 2:
          _logout();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bienvenue sur Trogo",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/workouts');
            },
            child: Builder(builder: (context) {
              if (currentUser == null) {
                return Text("Voir tous les entrainements");
              }
              return Text("Voir les entrainements en lien avec mon équipement");
            }),
          ),
        ],
      )),
      bottomNavigationBar: currentUser == null
          ? BottomNavigationBar(
              currentIndex: widget.currentIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Authentification',
                ),
              ],
            )
          : BottomNavigationBar(
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
                  label: 'Déconnexion',
                ),
              ],
            ),
    );
  }
}
