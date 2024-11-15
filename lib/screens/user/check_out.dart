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
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
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
  String _selectedPaymentMethod = 'paypal';

  @override
  void initState() {
    super.initState();
    // Initialize the address fetching future
    selectedAddress =
        BillingAddress(userEmail: widget.userEmail).fetchSelectedAddress();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.totalAmount ?? 0;
    double totalPrice = widget.totalPrice ?? 0;

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

              // Calculate total amount from cart items
              double subtotal = 0;
              for (var item in cartItems) {
                final int quantity =
                    int.tryParse(item.cartQuantity ?? '1') ?? 1;
                final int price =
                    int.tryParse(item.cartPrice?.replaceAll(",", "") ?? '1') ??
                        1;
                subtotal += quantity * price;
              }

              // Calculate shipping
              final double shipping = subtotal * 0.02;
              totalPrice = subtotal + shipping;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.2, // Adjust height as needed
                      child: CartItems(
                        userEmail: widget.userEmail,
                        showAddRemoveButton: false,
                      ),
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
                          BillingAmount(subtotal: subtotal),
                          const Divider(),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TitleContainer(
                                  title: "Phương thức thanh toán"),
                              const SizedBox(height: 10),
                              _buildPaymentOption(
                                  "Paypal", "assets/paypal.png", "paypal"),
                              const SizedBox(height: 10),
                              _buildPaymentOption(
                                  "Thanh toán khi nhận hàng",
                                  "assets/truck.png",
                                  "Thanh toán khi nhận hàng"),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TitleContainer(
                            title: "Địa chỉ giao hàng",
                            buttonTitle: "Thay đổi",
                            onPressed: () {
                              Get.to(() => UserAddressScreen(
                                  userEmail: widget.userEmail));
                            },
                            showActionButton: true,
                          ),
                          const SizedBox(height: 10),
                          BillingAddress(userEmail: widget.userEmail),
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
                  return;
                }

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

                // Calculate total amount from cart items
                double subtotal = 0;
                for (var item in cartItems) {
                  final int quantity =
                      int.tryParse(item.cartQuantity ?? '1') ?? 1;
                  final int price =
                      int.tryParse(item.cartPrice?.replaceAll(",", "") ?? '1') ??
                          1;
                  subtotal += quantity * price;
                }

                // Calculate shipping
                final double shipping = subtotal * 0.02;
                totalPrice = subtotal + shipping;

                // Handle PayPal payment method
                if (_selectedPaymentMethod == 'paypal') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => PaypalCheckout(
                        sandboxMode: true,
                        clientId:
                            "AcWNQ1RcUeyQ5VJ1ynt2rMeSznL6CIe3hwXlyM6uqykeX3rBSoUaZ5HKCZVtDJTJpJZifci7zQduHxfh", // Replace with actual Client ID
                        secretKey:
                            "EBliWVAbvYiprEJjNxm272asQpbWrVju9IgqkPW2YVIJpKLFEEX64SsHFmvQ6AJwgCvk2WMDMLuOGS1E", // Replace with actual Secret Key
                        returnURL: "success.snippetcoder.com",
                        cancelURL: "cancel.snippetcoder.com",
                        transactions: [
                          {
                            "amount": {
                              "total": totalPrice.toStringAsFixed(2),
                              "currency": "USD",
                              "details": {
                                "subtotal": subtotal.toStringAsFixed(2),
                                "shipping": shipping.toStringAsFixed(2),
                              },
                            },
                            "description": "Thanh toán đơn hàng",
                            "item_list": {
                              "items": cartItems
                                  .map(
                                    (item) => {
                                      "name": item.cartName,
                                      "quantity": item.cartQuantity,
                                      "price":
                                          item.cartPrice?.replaceAll(",", ""),
                                      "currency": "USD",
                                    },
                                  )
                                  .toList(),
                            },
                          }
                        ],
                        note:
                            "Cảm ơn bạn đã mua sắm tại cửa hàng của chúng tôi.",
                        onSuccess: (Map params) async {
                          // Success callback
                          print("onSuccess: $params");

                          Order order = Order(
                            userEmail: widget.userEmail,
                            totalAmount: totalPrice,
                            address:
                                "Số nhà: ${address.addressNumber}, Đường: ${address.addressStreet}, Phường: ${address.addressWard}, Quận: ${address.addressDistrict}, Thành Phố: ${address.addressCity}",
                            orderDate: DateTime.now().toString(),
                          );

                          final orderId =
                              await DatabaseHelper().createOrder(order);

                          if (orderId > 0) {
                            await DatabaseHelper().clearCart(widget.userEmail);
                            Get.to(
                              () => SuccessScreen(
                                title: 'Thanh toán thành công',
                                image: "assets/checked.png",
                                subtitle: "Đơn hàng của bạn sẽ sớm giao tới",
                                onPressed: () => Get.offAll(() =>
                                    HomePage(userEmail: widget.userEmail)),
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
                        },
                        onError: (error) {
                          print("onError: $error");
                          Get.snackbar(
                            'Lỗi',
                            'Đã xảy ra lỗi trong quá trình thanh toán!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ),
                  );
                }
                else if (_selectedPaymentMethod ==
                    'Thanh toán khi nhận hàng') {
                  // Handle Cash on Delivery (COD)
                  Order order = Order(
                    userEmail: widget.userEmail,
                    totalAmount: totalPrice,
                    address:
                        "Số nhà: ${address.addressNumber}, Đường: ${address.addressStreet}, Phường: ${address.addressWard}, Quận: ${address.addressDistrict}, Thành Phố: ${address.addressCity}",
                    orderDate: DateTime.now().toString(),
                  );

                  final orderId = await DatabaseHelper().createOrder(order);

                  if (orderId > 0) {
                    await DatabaseHelper().clearCart(widget.userEmail);
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
                print("Error during checkout: $e");
                Get.snackbar(
                  'Lỗi',
                  'Đã xảy ra lỗi trong quá trình thanh toán!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text(
              "Hoàn tất đơn hàng",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      String paymentMethodName, String paymentMethodIcon, String paymentMethod) {
    return RadioListTile<String>(
      value: paymentMethod,
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value!;
        });
      },
      title: Row(
        children: [
          Image.asset(paymentMethodIcon, width: 30,height: 30,),
          const SizedBox(width: 2),
          Text(paymentMethodName),
        ],
      ),
    );
  }
}
