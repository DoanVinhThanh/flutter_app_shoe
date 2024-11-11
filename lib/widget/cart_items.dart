import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/cart_sqlite.dart';
import 'package:flutter_/widget/product_price_text.dart';
import 'package:flutter_/widget/product_quantity_add_remove.dart';
import 'package:flutter_/widget/product_title_text.dart';
import 'package:flutter_/widget/round_Iamge.dart';


import 'package:intl/intl.dart';

class CartItems extends StatefulWidget {
  final bool showAddRemoveButton;
  final String userEmail;

  const CartItems({
    super.key,
    required this.userEmail,
    this.showAddRemoveButton = true,
  });

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
      future: DatabaseHelper().getCartItemsByEmail(widget.userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Lỗi khi tải giỏ hàng'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Giỏ hàng trống'));
        }

        final cartItems = snapshot.data!;
        return ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            final int quantity = int.tryParse(item.cartQuantity ?? '1') ?? 1;
            final int price =
                int.tryParse(item.cartPrice?.replaceAll(",", "") ?? "1") ?? 1;
            final int totalPrice = quantity * price;
            final String formattedTotalPrice =
                NumberFormat("#,##0").format(totalPrice);

            return Column(
              children: [
                Row(
                  children: [
                    RoundedImage(
                      imageUrl: item.cartImage!,
                      width: 70,
                      height: 70,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductTitleText(
                            title: item.cartName!,
                            maxLines: 1,
                            smallSize: true,
                          ),
                          Text.rich(TextSpan(
                            children: [
                              const TextSpan(
                                  text: "Color ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(text: item.cartColor),
                              const TextSpan(
                                  text: " Size ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(text: item.cartSize),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                widget.showAddRemoveButton
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProductQuantityWithAddAndRemove(
                            userEmail: widget.userEmail,
                            cartId: "${item.cartId}",
                            initialQuantity: quantity,
                            onQuantityChanged: (newQuantity, cartId) async {
                              await DatabaseHelper().updateCartQuantity(
                                  widget.userEmail, item.cartId!, newQuantity);
                              setState(() {});
                            },
                          ),
                          ProductPriceText(price: formattedTotalPrice),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Số lượng: $quantity',
                            style: const TextStyle(fontSize: 16),
                          ),
                          ProductPriceText(price: formattedTotalPrice),
                        ],
                      ),
                const Divider(),
              ],
            );
          },
        );
      },
    );
  }
}
