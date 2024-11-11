import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/products_sqlite.dart';
import 'package:flutter_/screens/admin/add_new_product_admin.dart';
import 'package:flutter_/screens/admin/edit_product_screen.dart';
import 'package:flutter_/widget/product_title_text.dart';



class ProductAdminScreen extends StatefulWidget {
  const ProductAdminScreen({super.key});

  @override
  _ProductAdminScreenState createState() => _ProductAdminScreenState();
}

class _ProductAdminScreenState extends State<ProductAdminScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts(); // Fetch products on init
  }

  Future<List<Product>> _fetchProducts() async {
    return await DatabaseHelper().getProducts(); // Fetch products from database
  }

  void _deleteProduct(int productId) async {
    await DatabaseHelper().deleteProduct(productId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted')),
    );
    // Refresh the product list
    setState(() {
      _productsFuture = _fetchProducts(); // Update future to refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            final products = snapshot.data!;

            return ListView.separated(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: product.productImage?.isNotEmpty == true
                            ? FileImage(File(product.productImage!))
                            : const AssetImage('assets/cat.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductTitleText(
                            title: product.productName ?? 'Unknown Product',
                            maxLines: 1,
                            smallSize: true,
                          ),
                          const SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Color: ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: product.productColor ?? 'N/A',
                                  style: const TextStyle(),
                                ),
                                const TextSpan(
                                  text: "  |  Size: ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: product.productSize ?? 'N/A',
                                  style: const TextStyle(),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProductScreen(product: product),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      _productsFuture = _fetchProducts(); // Refresh the product list when returning from edit screen
                                    });
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteProduct(product.productId!); // Delete the product
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
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          ).then((_) {
            setState(() {
              _productsFuture = _fetchProducts(); // Refresh the product list after adding a new product
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
