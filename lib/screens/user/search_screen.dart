import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/products_sqlite.dart';
import 'package:flutter_/screens/user/cart_screen.dart';
import 'package:flutter_/widget/cart_counter_icon.dart';
import 'package:flutter_/widget/grid_layout.dart';
import 'package:flutter_/widget/item_product.dart';
import 'package:flutter_/widget/title_container.dart';
import 'package:get/get.dart';


import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  final String? keyword;
  final String? categoryname;
  final String userEmail;

  const SearchScreen({super.key, required this.userEmail, this.categoryname, this.keyword});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();  
    _productsFuture = fetchProducts();
  }
  
  Future<List<Product>> fetchProducts() async {
    try {
      if (widget.categoryname != null) {
        return await DatabaseHelper().getProductsByCategoryName(widget.categoryname!);
      } else if(widget.keyword != null)
       {
        return await DatabaseHelper().searchProductsByKeyword(widget.keyword!);
      }else{
        return await DatabaseHelper().getProducts();
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tìm kiếm",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions:  [
          Padding(
            padding: EdgeInsets.all(5),
            child: CartCounterIcon(
              iconColor: Colors.black,
              counterBgColor: Colors.black,
              counterTextColor: Colors.white,
              onPressed: () => Get.to(CartScreen(userEmail: widget.userEmail)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
           
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TitleContainer(
                title: "Sản phẩm bạn tìm kiếm",
                showActionButton: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.sort),
                ),
                items: [
                  'Tên',
                  'Giá cao',
                  'Giá thấp',
                  'Giảm giá',
                  'Mới nhất',
                  'Phổ biến'
                ]
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
              ),
            ),
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Error: ${snapshot.error}"),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _productsFuture = fetchProducts();
                            });
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products available"));
                } else {
                  return GridLayout(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      final int price = int.tryParse(product.productPrice ?? '1') ?? 1;
                      final String formattedTotalPrice = NumberFormat("#,##0").format(price);

                      return ItemProduct(
                        userEmail: widget.userEmail,
                        image: product.productImage ?? 'assets/cat.png',
                        name: product.productName ?? 'No Name',
                        price: formattedTotalPrice,
                        description: product.productDescription ?? 'No Description',
                        images: (product.productImages ?? '')
                            .split(',')
                            .where((item) => item.isNotEmpty)
                            .toList(),
                        colors: (product.productColor ?? '')
                            .split(',')
                            .where((item) => item.isNotEmpty)
                            .toList(),
                        sizes: (product.productSize ?? '')
                            .split(',')
                            .where((item) => item.isNotEmpty)
                            .toList(),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
