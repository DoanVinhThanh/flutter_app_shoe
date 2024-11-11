import 'package:flutter/material.dart';
import 'package:flutter_/widget/circular_icon.dart';

class BottomAddToCart extends StatelessWidget {
  final int quantity; // Current quantity
  final VoidCallback? addOnPressed; // Callback for increment
  final VoidCallback? minusOnPressed; // Callback for decrement

  const BottomAddToCart({
    super.key,
    required this.quantity,
    this.addOnPressed,
    this.minusOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: minusOnPressed,
            width: 40,
            height: 40,
            icon: Icons.remove, // Changed to minus icon for clarity
            backgroundColor: Colors.white,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 20),
          Text(
            "$quantity", // Display current quantity
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          CircularIcon(
            onPressed: addOnPressed,
            width: 40,
            height: 40,
            icon: Icons.add, // Changed to plus icon for clarity
            backgroundColor: Colors.white,
            color: Colors.blue,
            size: 20,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Add your add to cart logic here
            },
            child: const Text(
              "Thêm vào giỏ hàng",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
