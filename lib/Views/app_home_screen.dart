import 'package:flutter/material.dart';
import 'package:rannabari_recipe_app/widget/banner.dart';
import 'package:rannabari_recipe_app/widget/food_items_display.dart';
import 'package:rannabari_recipe_app/widget/my_icon_button.dart';
import 'package:rannabari_recipe_app/utilities/constant.dart';
import 'package:rannabari_recipe_app/Views/view_all_items.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  String category = "All";
  final CollectionReference categoriesItems = FirebaseFirestore.instance
      .collection("app-category");
  Query get filteredRecipes => FirebaseFirestore.instance
      .collection("Complete_Flutter_App")
      .where('category', isEqualTo: category);
  Query get allRecipes =>
      FirebaseFirestore.instance.collection("Complete_Flutter_App");
  Query get selectedRecipes => category == "All" ? allRecipes : filteredRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    mySearchBar(),
                    BannerTo(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    selectedCategory(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick & Easy",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ), // TextStyle
                        ), // Text
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewAllItems(),
                              ),
                            ); // MaterialPageRoute
                          },
                          child: const Text(
                            "View all",
                            style: TextStyle(
                              color: kbannerColor,
                              fontWeight: FontWeight.w600,
                            ), // TextStyle
                          ), // Text
                        ), // TextButton
                      ], // Row children
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: selectedRecipes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> recipes =
                        snapshot.data?.docs ?? [];
                    return Padding(
                      padding: EdgeInsets.only(top: 5, left: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: recipes
                              .map((e) => FoodItemsDisplay(documentSnapshot: e))
                              .toList(),
                        ),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          category == streamSnapshot.data!.docs[index]["name"]
                          ? kprimarycolor
                          : Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: TextStyle(
                        color:
                            category == streamSnapshot.data!.docs[index]["name"]
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Padding mySearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Iconsax.search_normal),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: "Search any recipes",
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Row headerParts() {
    return Row(
      children: [
        Text(
          "What are you\ncooking today?",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const Spacer(),
        MyIconButton(icon: Iconsax.notification, pressed: () {}),
      ],
    );
  }
}
