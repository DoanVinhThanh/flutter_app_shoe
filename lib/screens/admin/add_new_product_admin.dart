import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/products_sqlite.dart';

import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _images = [];
  final List<String> _sizes = [];
  final List<String> _colors = [];

  final nameProduct = TextEditingController();
  final descriptionProduct = TextEditingController();
  final priceProduct = TextEditingController();

  String? _name;
  String? _description;
  String? _price;
  String? _colorInput;
  String? _sizeInput;

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

  // Function to select multiple additional images from the gallery
  Future<void> _pickImages() async {
    final List<XFile> pickedFiles =
        await _picker.pickMultiImage(imageQuality: 100);
    if (pickedFiles.length + _images.length <= 5) {
      setState(() {
        for (var file in pickedFiles) {
          _images.add(file.path); // Update image path
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 images allowed')),
      );
    }
  }

  void _addSize() {
    if (_sizeInput != null && _sizeInput!.isNotEmpty) {
      setState(() {
        _sizes.add(_sizeInput!); // Add size to the list
        _sizeInput = null; // Reset size input
      });
    }
  }

  void _addColor() {
    if (_colorInput != null && _colorInput!.isNotEmpty) {
      setState(() {
        _colors.add(_colorInput!); // Add color to the list
        _colorInput = null; // Reset color input
      });
    }
  }

  void _removeSize(int index) {
    setState(() {
      _sizes.removeAt(index); // Remove size by index
    });
  }

  void _removeColor(int index) {
    setState(() {
      _colors.removeAt(index); // Remove color by index
    });
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final newProduct = Product(
      productImage: imagePath,
      productName: _name,
      productDescription: _description,
      productPrice: _price,
      productSize: _sizes.join(', '),
      productColor: _colors.join(', '),
      productImages: _images.join(', '),
    );

    try {
      await DatabaseHelper().insertProduct(newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added: $_name')),
      );
      // Reset the form and navigate
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
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
                          const InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: descriptionProduct,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: priceProduct,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Price';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _price = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Size'),
                      onChanged: (value) {
                        _sizeInput = value; // Update size input value
                      },
                    ),
                    ElevatedButton(
                      onPressed: _addSize,
                      child: const Text('Add Size'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _sizes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_sizes[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeSize(index),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Color'),
                      onChanged: (value) {
                        _colorInput = value; // Update color input value
                      },
                    ),
                    ElevatedButton(
                      onPressed: _addColor,
                      child: const Text('Add Color'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _colors.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_colors[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeColor(index),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Images:'),
                    const SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(_images[index])),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.grey),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: const Text('Add Image'),
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
