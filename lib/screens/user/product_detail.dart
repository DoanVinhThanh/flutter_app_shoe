import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/cart_sqlite.dart';
import 'package:flutter_/screens/user/product_review_screen.dart';
import 'package:flutter_/widget/circular_icon.dart';
import 'package:flutter_/widget/prodcut_detail_data.dart';
import 'package:flutter_/widget/product_detail_image_slider.dart';
import 'package:flutter_/widget/rating_and_share.dart';
import 'package:flutter_/widget/title_container.dart';


import 'package:readmore/readmore.dart';

class ProductDetail extends StatefulWidget {

    final String userEmail;

  final String? image;
  final List<String>? images;
  final String? name;
  final String? description;
  final String? style;
  final String? price;
  final List<String>? colors;
  final List<String>? sizes;

  const ProductDetail({
    this.image,
    this.name,
    this.description,
    this.style,
    this.price,
    this.images,
    this.colors,
    this.sizes,
    super.key, required this.userEmail,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1; // Bắt đầu số lượng từ 1
  String? selectedColor;
  String? selectedSize;

  void _increment() {
    setState(() {
      quantity++;
    });
  }

  void _decrement() {
    setState(() {
      if (quantity > 1) quantity--; // Đảm bảo số lượng không nhỏ hơn 1
    });
  }

  void _addToCart()async {
  if (selectedColor == null || selectedSize == null) {
    // Kiểm tra nếu chưa chọn màu hoặc size
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vui lòng chọn màu và kích thước")),
    );
  } else if (quantity < 1) {
    // Kiểm tra nếu số lượng nhỏ hơn 1
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Số lượng phải lớn hơn 0")),
    );
  } 
  else {
    final newCart = Cart(
      cartImage: widget.image,
      cartName: widget.name,
      cartColor: selectedColor,
      cartSize: selectedSize,
      cartQuantity: "$quantity",
      cartPrice: widget.price,
      cartEmailUser: widget.userEmail,


    );

    try {
      await DatabaseHelper  ().insertCart(newCart);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cart added: $quantity')),
      );
      // Reset the form and navigate
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cart product: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            CircularIcon(
              onPressed: _decrement,
              width: 40,
              height: 40,
              icon: Icons.remove,
              backgroundColor: Colors.white,
              color: Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 20),
            Text(
              "$quantity",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            CircularIcon(
              onPressed: _increment,
              width: 40,
              height: 40,
              icon: Icons.add,
              backgroundColor: Colors.white,
              color: Colors.blue,
              size: 20,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _addToCart,
              child: const Text(
                "Thêm vào giỏ hàng",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImageSlider(
                images: widget.images ?? [], image: widget.image),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RatingAndShare(),
                  ProductDetailData(
                    name: widget.name,
                    price: widget.price,
                    style: "Men's shoe",
                  ),
                  // Lựa chọn màu
                  Row(
                    children: [
                      const Text("Màu:  ",style: TextStyle(fontSize: 16),),
                      DropdownButton<String>(
                        hint: const Text("Chọn màu"),
                        value: selectedColor,
                        onChanged: (value) {
                          setState(() {
                            selectedColor = value;
                          });
                        },
                        items: widget.colors?.map((color) {
                          return DropdownMenuItem(
                            value: color,
                            child: Text(color),
                          );
                        }).toList(),
                      ),
                      const Text("Kích thước:  ",style: TextStyle(fontSize: 16),),

                      // Lựa chọn size
                      DropdownButton<String>(
                        hint: const Text("Chọn size"),
                        value: selectedSize,
                        onChanged: (value) {
                          setState(() {
                            selectedSize = value;
                          });
                        },
                        items: widget.sizes?.map((size) {
                          return DropdownMenuItem(
                            value: size,
                            child: Text(size),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: () {
                        // Checkout function
                      },
                      child: const Text(
                        "Thanh toán",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TitleContainer(title: "Mô tả"),
                  const SizedBox(height: 10),
                  ReadMoreText(
                    widget.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: "Hiển thị",
                    trimExpandedText: "Rút gọn",
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    lessStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: TitleContainer(
                          title: "Review(200)",
                          showActionButton: false,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductReviewScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
