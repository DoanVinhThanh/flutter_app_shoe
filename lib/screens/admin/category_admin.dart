import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/category_sqlite.dart';
import 'package:flutter_/screens/admin/add_new_category_admin.dart';
import 'package:flutter_/widget/product_title_text.dart';



class CategoryAdminScreen extends StatefulWidget {
  const CategoryAdminScreen({super.key});

  @override
  _CategoryAdminScreenState createState() => _CategoryAdminScreenState();
}

class _CategoryAdminScreenState extends State<CategoryAdminScreen> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories(); // Fetch products on init
  }

  Future<List<Category>> _fetchCategories() async {
    return await DatabaseHelper().getCategories(); // Fetch products from database
  }

  void _deleteCategory(int categoryId) async {
    await DatabaseHelper().deleteCategories(categoryId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category deleted')),
    );
    // Refresh the product list
    setState(() {
      _categoriesFuture = _fetchCategories(); // Update future to refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Category>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found'));
            }

            final categories = snapshot.data!;

            return ListView.separated(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: category.categoryImage?.isNotEmpty == true
                            ? FileImage(File(category.categoryImage!))
                            : const AssetImage('assets/cat.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductTitleText(
                            title: category.categoryName ?? 'Unknown Product',
                            maxLines: 1,
                            smallSize: true,
                          ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteCategory(category.categoryId!); // Delete the product
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 20),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCategoryScreen()),
          ).then((_) {
            setState(() {
              _categoriesFuture = _fetchCategories(); // Refresh the product list after adding a new product
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
