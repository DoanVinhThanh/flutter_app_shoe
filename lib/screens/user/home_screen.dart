import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/controller/home_controller.dart';
import 'package:flutter_/models/products_sqlite.dart';
import 'package:flutter_/models/users_sqlite.dart';
import 'package:flutter_/screens/user/search_screen.dart';
import 'package:flutter_/widget/circular_container.dart';
import 'package:flutter_/widget/grid_layout.dart';
import 'package:flutter_/widget/home_app_bar.dart';
import 'package:flutter_/widget/item_product.dart';
import 'package:flutter_/widget/rounded_image.dart';
import 'package:flutter_/widget/title_container.dart';


import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    Users? user;
  final db = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _productsFuture = DatabaseHelper().getProducts(); // Fetch products on init
  }

  _loadUserData() async {
    var userData = await db.getUser(widget.userEmail);
    setState(() {
      user = userData;
    });
  }
  late Future<List<Product>> _productsFuture;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
             HomeAppBar(userEmail: widget.userEmail),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Slider(
                banners: [
                  "assets/banner1.jpg",
                  "assets/banner2.jpg",
                  "assets/banner3.jpg",
                ],
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: TitleContainer(title: "Sản phẩm nổi bật",showActionButton: true,onPressed: () => Get.to( SearchScreen(userEmail: widget.userEmail,),),),
            ),
            // Display products from SQLite using FutureBuilder
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No products available");
                } else {
                  // Use GridLayout to display products

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
                        images: (product.productImages ?? '').split(',').where((item) => item.isNotEmpty).toList(),
                        colors: (product.productColor ?? '').split(',').where((item) => item.isNotEmpty).toList(),
                        sizes: (product.productSize ?? '').split(',').where((item) => item.isNotEmpty).toList(),

                      );
                    },
                  );
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TitleContainer(title: "Sản phẩm khuyến mãi ",showActionButton: true,),
            ),
            // Display products from SQLite using FutureBuilder
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No products available");
                } else {
                  // Use GridLayout to display products
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
                        images: (product.productImages ?? '').split(',').where((item) => item.isNotEmpty).toList(),
                        colors: (product.productColor ?? '').split(',').where((item) => item.isNotEmpty).toList(),
                        sizes: (product.productSize ?? '').split(',').where((item) => item.isNotEmpty).toList(),

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



class Slider extends StatelessWidget {
  const Slider({
    super.key,
    required this.banners,
  });

  final List<String> banners;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, reason) =>
                controller.updatePageIndicator(index),
          ),
          items: banners.map((url) => RoundedImageBanner(imageUrl: url)).toList(),
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < 3; i++)
                CircularContainer(
                  width: 20,
                  height: 4,
                  backgroundColor: controller.carousalCurentindex.value == i
                      ? Colors.blue
                      : Colors.grey,
                  margin: const EdgeInsets.only(right: 10),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
