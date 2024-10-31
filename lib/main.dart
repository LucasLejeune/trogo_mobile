import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trogo_mobile/Views/Equipment/equipment_list.dart';
import 'package:trogo_mobile/Views/Workout/all_workout_list.dart';
import 'package:trogo_mobile/Views/auth/login_page.dart';
import 'package:trogo_mobile/Views/auth/register_page.dart';
import 'Views/home.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  primarySwatch: Colors.blue,
  hintColor: Colors.amber,
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 16.0),
    displayLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blueGrey,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blueGrey,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Trogo',
        initialRoute: '/',
        theme: theme,
        routes: {
          '/': (context) => const MyHomePage(
                title: 'Home',
                currentIndex: 0,
              ),
          '/equipment': (context) => EquipmentListScreen(),
          '/workouts': (context) => AllWorkoutsScreen(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage()
        },
      ),
    );
  }
}
