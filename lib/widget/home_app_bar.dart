import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/category_sqlite.dart';
import 'package:flutter_/models/users_sqlite.dart';
import 'package:flutter_/screens/user/cart_screen.dart';
import 'package:flutter_/screens/user/search_screen.dart';
import 'package:flutter_/widget/cart_counter_icon.dart';
import 'package:flutter_/widget/list_categories.dart';
import 'package:flutter_/widget/search_container.dart';
import 'package:flutter_/widget/title_container.dart';


import 'package:get/get.dart';
class HomeAppBar extends StatefulWidget {
  final String userEmail;
  const HomeAppBar({super.key, required this.userEmail});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  Users? user;
  final db = DatabaseHelper();
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _categoriesFuture = db.getCategories();
  }

  _loadUserData() async {
    var userData = await db.getUser(widget.userEmail);
    setState(() {
      user = userData;
    });
  }

  void _onSearchSubmitted(String keyword) {
    if (keyword.isNotEmpty) {
      Get.to(() => SearchScreen(
        userEmail: widget.userEmail,
        keyword: keyword,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade500,
            Colors.blue.shade400,
          ],
          begin: Alignment.topCenter,
        ),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Ngày tuyệt vời để mua sắm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user?.usrFullname ?? 'Đang tải...',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CartCounterIcon(
                iconColor: Colors.white,
                counterBgColor: Colors.black,
                counterTextColor: Colors.white,
                onPressed: () =>
                    Get.to(CartScreen(userEmail: widget.userEmail)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SearchContainer(
            onSearchSubmitted: _onSearchSubmitted,
            email: widget.userEmail,
          ),
          const SizedBox(height: 20),
          const TitleContainer(
            title: "Danh mục sản phẩm",
            colortitle: Colors.white,
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Category>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found.'));
              } else {
                final categories = snapshot.data!;
                return SizedBox(
                  height: 110,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return ListCategories(
                        userEmail: widget.userEmail,
                        image: categories[index].categoryImage ?? 'assets/cat.png',
                        textCategory: categories[index].categoryName ?? 'Cat',
                        onTap: () => Get.to(() => SearchScreen(
                              userEmail: widget.userEmail,
                              categoryname: categories[index].categoryName,
                            )),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


