import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rannabari_recipe_app/Views/app_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppMain());
}

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppMainScreen(),
    );
  }
}
