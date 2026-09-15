import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rannabari_recipe_app/Provider/auth_provider.dart';
import 'package:rannabari_recipe_app/Provider/favorite_provider.dart';
import 'package:rannabari_recipe_app/Provider/quantity.dart';
import 'package:rannabari_recipe_app/Views/app_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // for favorite provider
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        // for quantity provider
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppMain(),
      ), 
    ); 
  }
}