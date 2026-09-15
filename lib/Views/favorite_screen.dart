import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rannabari_recipe_app/Provider/favorite_provider.dart';
import 'package:rannabari_recipe_app/utilities/constant.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteItems = provider.favorites;

    return Scaffold(
      backgroundColor: kbackgroundcolor,
      appBar: AppBar(
        backgroundColor: kbackgroundcolor,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // AppBar
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                "No Favorites yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ), // Text
            ) // Center
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                String favorite = favoriteItems[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("Complete_Flutter_App")
                      .doc(favorite)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      ); // Center
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text("Error loading favorites"),
                      ); // Center
                    }

                    var favoriteItem = snapshot.data!;

                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ), // BoxDecoration
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        favoriteItem['image'],
                                      ),
                                    ), // NetworkImage
                                  ), // BoxDecoration
                                ), // Container
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      favoriteItem['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ), // TextStyle
                                    ), // Text
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Iconsax.flash_1,
                                          size: 16,
                                          color: Colors.grey,
                                        ), // Icon
                                        Text(
                                          "${favoriteItem['cal']} Cal",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ), // TextStyle
                                        ), // Text
                                        const SizedBox(width: 5),
                                        const Text(
                                          ".",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ), // TextStyle
                                        ), // Text
                                        const SizedBox(width: 5),
                                        const Icon(
                                          Iconsax.clock,
                                          size: 16,
                                          color: Colors.grey,
                                        ), // Icon
                                        const SizedBox(width: 5),
                                        Text(
                                          "${favoriteItem['time']} Min",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ), // TextStyle
                                        ), // Text
                                      ],
                                    ), // Row
                                  ],
                                ), // Column
                              ],
                            ), // Row
                          ), // Container
                        ), // Padding
                        // for delete button
                        Positioned(
                          top: 50,
                          right: 35,
                          child: GestureDetector(
                            onTap: () {
                              provider.toggleFavorite(favoriteItem);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ), // Icon
                          ), // GestureDetector
                        ), // Positioned
                      ],
                    ); // Stack
                  },
                ); // FutureBuilder
              },
            ), // ListView.builder
    ); // Scaffold
  }
}