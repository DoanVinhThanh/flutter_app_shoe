import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/category_sqlite.dart';
import 'package:flutter_/screens/admin/category_admin.dart';


import 'package:image_picker/image_picker.dart';

class EditCategorytScreen extends StatefulWidget {
  final Category category;

  const EditCategorytScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<EditCategorytScreen> createState() => _EditCategorytScreenState();
}

class _EditCategorytScreenState extends State<EditCategorytScreen> {
  final _formKey = GlobalKey<FormState>();


  final nameCategory = TextEditingController();


  String? _name;
  String imagePath = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();


  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedCategory = Category(
        categoryId: widget.category.categoryId, // Retain the ID for updating
        categoryImage: imagePath,
        categoryName: _name,

      );

      await DatabaseHelper().updateCategories(updatedCategory);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated: $_name')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CategoryAdminScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircleAvatar(
                        backgroundImage: imagePath.isNotEmpty
                            ? FileImage(File(imagePath))
                            : const AssetImage('assets/cat.png') as ImageProvider,
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: nameCategory,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
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
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
