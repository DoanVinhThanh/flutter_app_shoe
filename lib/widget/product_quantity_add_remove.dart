import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/widget/circular_icon.dart';



class ProductQuantityWithAddAndRemove extends StatefulWidget {
  final int initialQuantity;
  final Function(int quantity, String cartId) onQuantityChanged; // Callback với cartId
  final String userEmail;
  final String cartId;

  ProductQuantityWithAddAndRemove({
    super.key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
    required this.userEmail,
    required this.cartId,
  });

  @override
  _ProductQuantityWithAddAndRemoveState createState() => _ProductQuantityWithAddAndRemoveState();
}

class _ProductQuantityWithAddAndRemoveState extends State<ProductQuantityWithAddAndRemove> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity; // Khởi tạo số lượng
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
      widget.onQuantityChanged(quantity, widget.cartId); // Cập nhật số lượng cho sản phẩm
    });
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      if (quantity == 1) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Xóa sản phẩm"),
              content: const Text("Bạn có muốn xóa sản phẩm khỏi giỏ hàng không?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: const Text("Hủy"),
                ),
                TextButton(
                  onPressed: () {
                    DatabaseHelper().deleteCartItem(widget.userEmail, widget.cartId); // Xóa sản phẩm
                    Navigator.of(context).pop(); // Đóng dialog
                    widget.onQuantityChanged(0, widget.cartId); // Cập nhật số lượng về 0
                  },
                  child: const Text("Xóa"),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          quantity--;
          widget.onQuantityChanged(quantity, widget.cartId); // Cập nhật số lượng cho sản phẩm
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularIcon(
          width: 32,
          height: 32,
          size: 16,
          icon: Icons.keyboard_arrow_down,
          color: Colors.black,
          backgroundColor: const Color.fromARGB(255, 239, 232, 232),
          onPressed: _decrementQuantity,
        ),
        const SizedBox(width: 15),
        Text(
          "$quantity",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15),
        CircularIcon(
          width: 32,
          height: 32,
          size: 16,
          icon: Icons.keyboard_arrow_up,
          color: Colors.white,
          backgroundColor: Colors.blue,
          onPressed: _incrementQuantity,
        ),
      ],
    );
  }
}

