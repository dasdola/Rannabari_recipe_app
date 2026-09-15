import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rannabari_recipe_app/Provider/favorite_provider.dart';
import 'package:rannabari_recipe_app/Provider/quantity.dart';
import 'package:rannabari_recipe_app/widget/my_icon_button.dart';
import 'package:rannabari_recipe_app/widget/quantity_increment_decrement.dart';
import 'package:rannabari_recipe_app/utilities/constant.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    List<double> baseAmounts = widget.documentSnapshot['ingredientsAmount']
        .map<double>((amount) => double.parse(amount.toString()))
        .toList();
    Provider.of<QuantityProvider>(context, listen: false)
        .setBaseIngredientAmounts(baseAmounts);
  });
}

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavoriteButton(
        provider,
        widget.documentSnapshot,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.documentSnapshot['image'],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.documentSnapshot['image'],
                        ),
                      ), // DecorationImage
                    ), // BoxDecoration
                  ), // Container
                ), // Hero
                // for back button
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10, 
                  child: Row(
                    children: [
                      MyIconButton(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ), // MyIconButton
                      const Spacer(),
                      MyIconButton(
                        icon: Iconsax.notification,
                        pressed: () {},
                      ), // MyIconButton
                    ],
                  ), // Row
                ), // Positioned
              ],
            ), // Stack
            // for drag handle
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ), // Container
            ), // Center
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ), // TextStyle
                  ), // Text
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.flash_1,
                        size: 16,
                        color: Colors.grey,
                      ), // Icon
                      Text(
                        "${widget.documentSnapshot['cal']} Cal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ), // TextStyle
                      ), // Text
                      const Text(
                        " . ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ), // TextStyle
                      ), // Text
                      const Icon(
                        Iconsax.clock,
                        size: 20,
                        color: Colors.grey,
                      ), // Icon
                      const SizedBox(width: 5),
                      Text(
                        "${widget.documentSnapshot['time']} Min",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ), // TextStyle
                      ), // Text
                    ],
                  ), // Row
                  const SizedBox(height: 10),
                  // for rating
                  Row(
                    children: [
                      const Icon(
                        Iconsax.star1,
                        color: Colors.amberAccent,
                      ), // Icon
                      const SizedBox(width: 5),
                      Text(
                        widget.documentSnapshot['rate'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ), // TextStyle
                      ), // Text
                      const Text("/5"),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.documentSnapshot['reviews'].toString()} Reviews",
                        style: const TextStyle(
                          color: Colors.grey,
                        ), // TextStyle
                      ), // Text
                    ],
                  ), // Row
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ), // TextStyle
                          ), // Text
                          const SizedBox(height: 10),
                          const Text(
                            "How many servings?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ), // TextStyle
                          ), // Text
                        ],
                      ), // Column
                      const Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.increaseQuantity(),
                        onRemov: () => quantityProvider.decreaseQuantity(),
                      ),
                    ],
                  ), // Row
                  const SizedBox(height: 10),
                  // list of ingredients
                  Column(
                    children: [
                      Row(
                        children: [
                          // ingredients images
                          Column(
                            children: widget.documentSnapshot['ingredientsImage']
                                .map<Widget>(
                                  (imageUrl) => Container(
                                    height: 60,
                                    width: 60,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          imageUrl,
                                        ),
                                      ), // DecorationImage
                                    ), // BoxDecoration
                                  ), // Container
                                )
                                .toList(),
                          ), // Column
                          const SizedBox(width: 20),
                          // ingredients names
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.documentSnapshot['ingredientsName']
                                .map<Widget>(
                                  (ingredient) => SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        ingredient,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade400,
                                        ), // TextStyle
                                      ), // Text
                                    ), // Center
                                  ), // SizedBox
                                )
                                .toList(),
                          ), // Column
                          const Spacer(),
                          // ingredient amount
                          Column(
                            children: quantityProvider.updateIngredientAmounts
                                .map<Widget>(
                                  (amount) => SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        "${amount}gm",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade400,
                                        ), // TextStyle
                                      ), // Text
                                    ), // Center
                                  ), // SizedBox
                                )
                                .toList(),
                          ), // Column
                        ],
                      ), // Row
                    ],
                  ), // Column
                ],
              ), // Column
            ), // Padding
          ],
        ), // Column
      ), // SingleChildScrollView
    ); // Scaffold
  }
}

FloatingActionButton startCookingAndFavoriteButton(
  FavoriteProvider provider,
  DocumentSnapshot documentSnapshot,
) {
  return FloatingActionButton.extended(
    backgroundColor: Colors.transparent,
    elevation: 0,
    onPressed: () {},
    label: Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kprimarycolor,
            padding: const EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 13,
            ),
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: const Text(
            "Start Cooking",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ), // Text
        ), // ElevatedButton
        const SizedBox(width: 10),
        IconButton(
          style: IconButton.styleFrom(
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.grey.shade300,
                width: 2,
              ), // BorderSide
            ), // CircleBorder
          ),
          onPressed: () {
            provider.toggleFavorite(documentSnapshot);
          },
          icon: Icon(
            provider.isExist(documentSnapshot)
                ? Iconsax.heart5
                : Iconsax.heart,
            color: provider.isExist(documentSnapshot)
                ? Colors.red
                : Colors.black,
            size: 22,
          ), // Icon
        ), // IconButton
      ],
    ), // Row
  );
}