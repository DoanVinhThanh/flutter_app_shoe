import 'package:flutter/material.dart';
import 'package:flutter_/widget/product_price_text.dart';
import 'package:flutter_/widget/product_title_text.dart';
import 'package:flutter_/widget/rounded_container.dart';



class ProductDetailData extends StatelessWidget {
  final String? name;
  final String? price;
  final String? style;

  const ProductDetailData({
    super.key, this.name, this.price, this.style,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const RoundedContainer(
              radius: 10,
              backgroundColor: Colors.yellow,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "25%",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const ProductPriceText(
              price: "2.500.000",
              isLarge: false,
            ),
            const SizedBox(
              width: 10,
            ),
            ProductPriceText(
              price: price ?? "No Price",
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ProductTitleText(title: name ?? "No Name"),
      ],
    );
  }
}
