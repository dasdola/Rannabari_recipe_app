import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rannabari_recipe_app/widget/my_icon_button.dart';
import 'package:rannabari_recipe_app/widget/food_items_display.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rannabari_recipe_app/utilities/constant.dart';

final CollectionReference completeApp =
    FirebaseFirestore.instance.collection('Complete_Flutter_App');

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundcolor,
      appBar: AppBar(
        backgroundColor: kbackgroundcolor,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          const SizedBox(width: 15),
          MyIconButton(
            icon: Icons.arrow_back_ios,
            pressed: () {
              Navigator.pop(context);
            },
          ), // MyIconButton
          const Spacer(),
          const Text(
            "Quick & Easy",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // TextStyle
          ), // Text
          const Spacer(),
          MyIconButton(
            icon: Iconsax.notification,
            pressed: () {},
          ), // MyIconButton
          const SizedBox(width: 15),
        ], // actions
      ), // AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder(
              stream: completeApp.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                    ), // SliverGridDelegateWithFixedCrossAxisCount
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return FoodItemsDisplay(
                        documentSnapshot: documentSnapshot,
                      );
                    },
                  ); // GridView.builder
                }

                return const Center(
                  child: CircularProgressIndicator(),
                ); // Center
              },
            ), // StreamBuilder
          ],
        ),
      ),
    );
  }
}