import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rannabari_recipe_app/utilities/constant.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // main recipe fields
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();
  final _calController = TextEditingController();
  final _timeController = TextEditingController();
  final _rateController = TextEditingController();
  final _reviewsController = TextEditingController();

  // one controller-trio per ingredient row: [name, image, amount]
  final List<List<TextEditingController>> _ingredientRows = [
    [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ],
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _calController.dispose();
    _timeController.dispose();
    _rateController.dispose();
    _reviewsController.dispose();
    for (final row in _ingredientRows) {
      for (final controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _addIngredientRow() {
    setState(() {
      _ingredientRows.add([
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ]);
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredientRows.length == 1) return; // keep at least one row
    setState(() {
      _ingredientRows.removeAt(index);
    });
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final ingredientsName =
          _ingredientRows.map((row) => row[0].text.trim()).toList();
      final ingredientsImage =
          _ingredientRows.map((row) => row[1].text.trim()).toList();
      // ingredientsAmount is stored as double in Firestore,
      // so parse to double here as well
      final ingredientsAmount = _ingredientRows
          .map((row) => double.tryParse(row[2].text.trim()) ?? 0.0)
          .toList();

      await FirebaseFirestore.instance.collection('Complete_Flutter_App').add({
        'name': _nameController.text.trim(),
        'image': _imageController.text.trim(),
        'category': _categoryController.text.trim(),
        // cal is also stored as double in your collection
        'cal': double.tryParse(_calController.text.trim()) ?? 0.0,
        'time': _timeController.text.trim(),
        'rate': _rateController.text.trim(),
        'reviews': int.tryParse(_reviewsController.text.trim()) ?? 0,
        'ingredientsName': ingredientsName,
        'ingredientsImage': ingredientsImage,
        'ingredientsAmount': ingredientsAmount,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipe added successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add recipe: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ); // InputDecoration
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add New Recipe",
          style: TextStyle(fontWeight: FontWeight.bold),
        ), // Text
      ), // AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recipe Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ), // Text
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: _decoration("Recipe Name"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ), // TextFormField
              const SizedBox(height: 12),

              TextFormField(
                controller: _imageController,
                decoration: _decoration("Image URL"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ), // TextFormField
              const SizedBox(height: 12),

              TextFormField(
                controller: _categoryController,
                decoration:
                    _decoration("Category (e.g. Dinner, Lunch, Breakfast)"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ), // TextFormField
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _calController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration("Calories"),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? "Required" : null,
                    ), // TextFormField
                  ), // Expanded
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration("Time (min)"),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? "Required" : null,
                    ), // TextFormField
                  ), // Expanded
                ],
              ), // Row
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: _decoration("Rating (e.g. 4.5)"),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? "Required" : null,
                    ), // TextFormField
                  ), // Expanded
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _reviewsController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration("Reviews Count"),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? "Required" : null,
                    ), // TextFormField
                  ), // Expanded
                ],
              ), // Row

              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ), // Text
                  TextButton.icon(
                    onPressed: _addIngredientRow,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Ingredient"),
                  ), // TextButton.icon
                ],
              ), // Row
              const SizedBox(height: 8),

              // one card per ingredient row
              ..._ingredientRows.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ), // BoxDecoration
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ingredient ${index + 1}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ), // Text
                          if (_ingredientRows.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () => _removeIngredientRow(index),
                            ), // IconButton
                        ],
                      ), // Row
                      TextFormField(
                        controller: row[0],
                        decoration: _decoration("Ingredient Name"),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Required"
                            : null,
                      ), // TextFormField
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: row[1],
                        decoration: _decoration("Ingredient Image URL"),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Required"
                            : null,
                      ), // TextFormField
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: row[2],
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration:
                            _decoration("Amount (grams, for 1 serving)"),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Required"
                            : null,
                      ), // TextFormField
                    ],
                  ), // Column
                ); // Container
              }),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimarycolor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ), // RoundedRectangleBorder
                  ),
                  onPressed: _isSubmitting ? null : _submitRecipe,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ), // CircularProgressIndicator
                        ) // SizedBox
                      : const Text(
                          "Save Recipe",
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ), // Text
                ), // ElevatedButton
              ), // SizedBox
              const SizedBox(height: 20),
            ],
          ), // Column
        ), // Form
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
