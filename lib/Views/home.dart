import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
      switch (index) {
      case 0:
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case 1:
        Navigator.pushNamed(context, '/login');
        break;
      case 2: 
        Navigator.pushNamed(context, '/equipment');
        break;
      default:
        setState(() {
          _selectedIndex = 0;
        });
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
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text("Se connecter"),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Entrainement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Connexion',
          ),
        ],
      )
    );
  }
}
