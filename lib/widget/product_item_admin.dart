import 'package:flutter/material.dart';
import 'package:flutter_/widget/product_title_text.dart';
import 'package:flutter_/widget/round_Iamge.dart';



class ProductItemAdmin extends StatelessWidget {
  const ProductItemAdmin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => const Column(
        children: [
          Row(
      children: [
        RoundedImage(
          imageUrl: "assets/killshot2.png",
          width: 70,
          height: 70,
          padding: EdgeInsets.all(8.0),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: ProductTitleText(
                    title:
                        "Nike Killshot 2 ",
                    maxLines: 1,
                    smallSize: true,
                  )),
                  Text.rich(TextSpan(
                    children: [
                      TextSpan(
                        text: "Color ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: "Blue ",
                        style: TextStyle(),
                      ),
                      TextSpan(
                        text: "Size ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: "EU 40",
                        style: TextStyle(),
                      ),
                    ],
                  )),
                ],
              ),
              Icon(Icons.edit),
              Icon(Icons.delete),

            ],
          ),
        ),
      ],
    ),
        ],
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
      itemCount: 3,
    );
  }
}
