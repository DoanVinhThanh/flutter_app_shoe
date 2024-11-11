import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/cart_sqlite.dart';
import 'package:flutter_/models/users_sqlite.dart';
import 'package:flutter_/screens/user/check_out.dart';
import 'package:flutter_/widget/billing_amount.dart';
import 'package:flutter_/widget/cart_items.dart';
import 'package:flutter_/widget/rounded_container.dart';


import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  final String userEmail;

  const CartScreen({super.key, required this.userEmail});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Users? user;
  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 5));
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Giỏ hàng của bạn"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<List<Cart>>(
            future: db.getCartItemsByEmail(widget.userEmail),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Lỗi khi tải giỏ hàng'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Giỏ hàng trống'));
              }

              final cartItems = snapshot.data!;
              double totalAmount = 0;

              // Calculate total amount from cart items
              for (var item in cartItems) {
                final int quantity =
                    int.tryParse(item.cartQuantity ?? '1') ?? 1;
                final int price =
                    int.tryParse(item.cartPrice?.replaceAll(",", "") ?? '1') ?? 1;
                totalAmount += quantity * price;
              }

              // Calculate shipping and total price
              final double shipping = totalAmount * 0.02;
              final double totalPrice = totalAmount + shipping;

              return Column(
                children: [
                  Expanded(
                    child: CartItems(userEmail: widget.userEmail),
                  ),
                  RoundedContainer(
                    padding: const EdgeInsets.all(16),
                    showBorder: true,
                    backgroundColor: Colors.white,
                    child: BillingAmount(subtotal: totalAmount),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                        ),
                        onPressed: () async {
                          final cartItems = await DatabaseHelper()
                              .getCartItemsByEmail(widget.userEmail);
                          if (cartItems.isEmpty) {
                            Get.snackbar(
                              'Thông báo',
                              'Giỏ hàng của bạn đang trống!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.to(() => CheckOutScreen(
                                  userEmail: widget.userEmail,
                                  totalAmount: totalAmount,
                                  totalPrice: totalPrice, // Pass total price here
                                ));
                          }
                        },
                        child: const Text(
                          "Thanh toán",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
