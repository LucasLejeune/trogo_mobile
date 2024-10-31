import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const Navbar({Key? key, required this.child, required this.currentIndex}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
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
      appBar: AppBar(title: Text("Application")),
      body: widget.child,
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