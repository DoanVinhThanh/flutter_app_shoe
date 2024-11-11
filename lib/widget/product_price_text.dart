import 'package:flutter/material.dart';

class ProductPriceText extends StatelessWidget {
  final String currencySign, price;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;
  const ProductPriceText({
    super.key,
    this.currencySign = " VND",
    required this.price,
     this.maxLines =1 ,
     this.isLarge = true,
     this.lineThrough = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      price + currencySign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,

      style: isLarge 
      ?const TextStyle(fontSize: 20):const TextStyle(fontSize: 18,decoration: TextDecoration.lineThrough), 
      
      
    );
  }
}
