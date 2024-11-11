import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingAmount extends StatelessWidget {
  final double? subtotal;

  const BillingAmount({super.key, this.subtotal});

  @override
  Widget build(BuildContext context) {
    final double shipping = subtotal! * 0.02;
    final double totalPrice = subtotal! + shipping;

    final String formattedSubtotal = NumberFormat("#,##0").format(subtotal);
    final String formattedShipping = NumberFormat("#,##0").format(shipping);
    final String formattedTotalPrice = NumberFormat("#,##0").format(totalPrice);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tạm tính: "),
            Text(formattedSubtotal),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Vận chuyển: "),
            Text(formattedShipping),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mã giảm giá: "),
            Text("0"),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tổng cộng: "),
            Text(formattedTotalPrice),
          ],
        ),
      ],
    );
  }
}
