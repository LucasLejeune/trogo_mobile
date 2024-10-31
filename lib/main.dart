import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trogo_mobile/Views/Equipment/equipment_list.dart';
import 'package:trogo_mobile/Views/Workout/all_workout_list.dart';
import 'package:trogo_mobile/Views/auth/login_page.dart';
import 'package:trogo_mobile/Views/auth/register_page.dart';
import 'Views/home.dart';
import 'firebase_options.dart';

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
