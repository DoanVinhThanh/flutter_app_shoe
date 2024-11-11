import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/menu/bottom_navigation_bar.dart';
import 'package:flutter_/models/address_sqlite.dart';
import 'package:flutter_/models/cart_sqlite.dart';
import 'package:flutter_/models/order_sqlite.dart';
import 'package:flutter_/screens/user/address_screen.dart';
import 'package:flutter_/screens/user/success_screen.dart';
import 'package:flutter_/widget/billing_address.dart';
import 'package:flutter_/widget/billing_amount.dart';
import 'package:flutter_/widget/billing_payment.dart';
import 'package:flutter_/widget/cart_items.dart';
import 'package:flutter_/widget/discount_code.dart';
import 'package:flutter_/widget/rounded_container.dart';
import 'package:flutter_/widget/title_container.dart';


import 'package:get/get.dart';

class CheckOutScreen extends StatefulWidget {
  final String userEmail;
  final double? totalAmount;
  final double? totalPrice;

  const CheckOutScreen({
    super.key,
    this.totalAmount, // Pass this from CartScreen
    required this.userEmail,
    this.totalPrice, // Pass this from CartScreen
  });

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late Future<Address?> selectedAddress;

  @override
  void initState() {
    super.initState();
    // Initialize the address fetching future
    selectedAddress =
        BillingAddress(userEmail: widget.userEmail).fetchSelectedAddress();
  }

  @override
  Widget build(BuildContext context) {
    // Use the totalPrice passed from CartScreen, if available
    double totalPrice = widget.totalPrice ?? 0; // Use default value if not passed

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán đơn hàng"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<List<Cart>>(
            future: DatabaseHelper()
                .getCartItemsByEmail(widget.userEmail), // Load cart items
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
                    int.tryParse(item.cartPrice?.replaceAll(",", "") ?? '1') ??
                        1;
                totalAmount += quantity * price;
              }
              
              // Calculate shipping if not passed totalPrice
              final double shipping = totalAmount * 0.02;
              totalPrice = totalAmount + shipping;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2, // Adjust height as needed

                      child: CartItems(
                          userEmail: widget.userEmail,
                          showAddRemoveButton: false),
                    ),
                    const SizedBox(height: 5),
                    const DiscountCode(),
                    const SizedBox(height: 10),
                    RoundedContainer(
                      padding: const EdgeInsets.all(8),
                      showBorder: true,
                      backgroundColor: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          BillingAmount(subtotal: totalAmount),
                          const Divider(),
                          const SizedBox(height: 10),
                          const BillingPayment(),
                          const SizedBox(height: 10),
                          TitleContainer(
                            title: "Địa chỉ giao hàng",
                            buttonTitle: "Thay đổi",
                            onPressed: () {
                              Get.to(() =>
                                  UserAddressScreen(userEmail: widget.userEmail));
                            },
                            showActionButton: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BillingAddress(
                            userEmail: widget.userEmail,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue),
            ),
            onPressed: () async {
              try {
                //await StripeService.initPaymentSheet("$totalPrice", "VND");
                //await StripeService.presentPaymentSheet();
                // Get the cart items for the current user
                final cartItems = await DatabaseHelper()
                    .getCartItemsByEmail(widget.userEmail);

                if (cartItems.isEmpty) {
                  // Show a message if the cart is empty
                  Get.snackbar(
                    'Thông báo',
                    'Giỏ hàng của bạn đang trống!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  // Fetch the selected address
                  final address = await selectedAddress;

                  if (address == null) {
                    Get.snackbar(
                      'Thông báo',
                      'Vui lòng chọn địa chỉ giao hàng!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // Create the order
                  Order order = Order(
                    userEmail: widget.userEmail,
                    totalAmount: totalPrice, // Use totalPrice passed here
                    address:
                        "Số nhà: ${address.addressNumber}, Đường: ${address.addressStreet}, Phường: ${address.addressWard}, Quận: ${address.addressDistrict}, Thành Phố: ${address.addressCity}",
                    orderDate: DateTime.now().toString(),
                  );

                  // Use orderId to check if the order creation was successful
                  final orderId = await DatabaseHelper().createOrder(order);

                  if (orderId > 0) {
                    // Clear the cart after order creation
                    await DatabaseHelper().clearCart(widget.userEmail);

                    // Show success screen
                    Get.to(
                      () => SuccessScreen(
                        title: 'Thanh toán thành công',
                        image: "assets/checked.png",
                        subtitle: "Đơn hàng của bạn sẽ sớm giao tới",
                        onPressed: () => Get.offAll(
                            () => HomePage(userEmail: widget.userEmail)),
                      ),
                    );
                  } else {
                    Get.snackbar(
                      'Lỗi',
                      'Đã xảy ra lỗi khi tạo đơn hàng, vui lòng thử lại!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              } catch (e) {
                Get.snackbar(
                  'Lỗi',
                  'Đã xảy ra lỗi: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text(
              "Thanh toán",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
