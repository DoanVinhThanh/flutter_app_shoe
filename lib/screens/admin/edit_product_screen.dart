import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/products_sqlite.dart';
import 'package:flutter_/screens/admin/product_admin.dart';


import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _images = [];
  final List<String> _sizes = [];
  final List<String> _colors = [];

  final nameProduct = TextEditingController();
  final descriptionProduct = TextEditingController();
  final priceProduct = TextEditingController();
  final colorProduct = TextEditingController();
  final sizeProduct = TextEditingController();

  String? _name;
  String? _description;
  String? _price;
  String imagePath = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    imagePath = widget.product.productImage!;
    nameProduct.text = widget.product.productName!;
    descriptionProduct.text = widget.product.productDescription!;
    priceProduct.text = widget.product.productPrice!;
    _sizes.addAll(widget.product.productSize!.split(', '));
    _colors.addAll(widget.product.productColor!.split(', '));
    _images.addAll(widget.product.productImages!.split(', '));
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

      final updatedProduct = Product(
        productId: widget.product.productId, // Retain the ID for updating
        productImage: imagePath,
        productName: _name,
        productDescription: _description,
        productPrice: _price,
        productSize: _sizes.join(', '),
        productColor: _colors.join(', '),
        productImages: _images.join(', '),
      );

      await DatabaseHelper().updateProduct(updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated: $_name')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductAdminScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
                  controller: nameProduct,
                  decoration: const InputDecoration(labelText: 'Product Name'),
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
                  decoration: const InputDecoration(labelText: 'Description'),
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
                  decoration: const InputDecoration(labelText: 'Price'),
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
                // Implement similar fields for sizes and colors
                // Call _submitForm() when the user submits the form
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
