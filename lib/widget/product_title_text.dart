import 'package:flutter/material.dart';

class ProductTitleText extends StatelessWidget {
  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign? textAlign;
  const ProductTitleText(
      {super.key,
      required this.title,
       this.smallSize = false,
       this.maxLines = 2,
      this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: smallSize ? const TextStyle(fontSize: 18):TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
