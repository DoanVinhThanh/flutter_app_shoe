import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/category_sqlite.dart';


import 'package:image_picker/image_picker.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();


  final nameProduct = TextEditingController();
  String? _name;



  String imagePath = 'assets/cat.png'; // Default image path
  final ImagePicker _picker = ImagePicker();

  // Function to select the main image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // Update image path
      });
    }
  }
  

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final newCategory = Category(
      categoryImage: imagePath,
      categoryName: _name,
    );

    try {
      await DatabaseHelper().insertCategories(newCategory);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category added: $_name')),
      );
      // Reset the form and navigate
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding Category: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircleAvatar(
                      backgroundImage: FileImage(File(imagePath)),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameProduct,
                      decoration:
                          const InputDecoration(labelText: 'Category Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Category name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value;
                      },
                    ),          
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
