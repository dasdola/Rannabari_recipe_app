import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rannabari_recipe_app/Provider/auth_provider.dart';
import 'package:rannabari_recipe_app/Views/add_recipe_screen.dart';
import 'package:rannabari_recipe_app/Views/login_screen.dart';
import 'package:rannabari_recipe_app/utilities/constant.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ), // TextStyle
        ), // Text
      ), // AppBar
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: authProvider.isLoggedIn
            ? _loggedInView(context, authProvider)
            : _loggedOutView(context),
      ), // Padding
    ); // Scaffold
  }

  // shown when a user IS logged in
  Widget _loggedInView(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 32),
            ), // CircleAvatar
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName?.isNotEmpty == true
                        ? user!.displayName!
                        : "User",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ), // TextStyle
                  ), // Text
                  Text(
                    user?.email ?? "",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ), // TextStyle
                  ), // Text
                ],
              ), // Column
            ), // Expanded
          ],
        ), // Row
        const SizedBox(height: 30),

        // add recipe
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.add_circle_outline, color: Colors.black),
          title: const Text("Add New Recipe"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRecipeScreen(),
              ), // MaterialPageRoute
            );
          },
        ), // ListTile
        const Divider(),

        // logout
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.red),
          ), // Text
          onTap: () => authProvider.logout(),
        ), // ListTile
      ],
    ); // Column
  }

  // shown when NO user is logged in
  Widget _loggedOutView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.account_circle, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        const Text(
          "You're not logged in",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ), // TextStyle
        ), // Text
        const SizedBox(height: 8),
        const Text(
          "Login to save favorites and add your own recipes",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ), // Text
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimarycolor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ), // RoundedRectangleBorder
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ), // MaterialPageRoute
              );
            },
            child: const Text(
              "Login / Register",
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Text
          ), // ElevatedButton
        ), // SizedBox
      ],
    ); // Column
  }
}
