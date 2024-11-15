import 'package:flutter/material.dart';
import 'package:flutter_/widget/rounded_container.dart';
import 'package:flutter_/widget/title_container.dart';



class BillingPayment extends StatefulWidget {
  const BillingPayment({super.key});

  @override
  _BillingPaymentState createState() => _BillingPaymentState();
}

class _BillingPaymentState extends State<BillingPayment> {
  String _selectedPaymentMethod = 'paypal';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleContainer(title: "Phương thức thanh toán"),
        const SizedBox(height: 10),
        _buildPaymentOption("Paypal", "assets/paypal.png", "paypal"),
        const SizedBox(height: 10),
        _buildPaymentOption("Thanh toán khi nhận hàng", "assets/truck.png", "Thanh toán khi nhận hàng"),

      ],
    );
  }

  Widget _buildPaymentOption(String title, String imagePath, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedPaymentMethod,
          onChanged: (String? newValue) {
            setState(() {
              _selectedPaymentMethod = newValue!;
            });
          },
        ),
        RoundedContainer(
          width: 40,
          height: 40,
          backgroundColor: Colors.white,
          
          child: Image(image: AssetImage(imagePath)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
