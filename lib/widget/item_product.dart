import 'package:flutter/material.dart';
import 'package:flutter_/screens/user/product_detail.dart';
import 'package:flutter_/widget/circular_icon.dart';
import 'package:flutter_/widget/round_Iamge.dart';
import 'package:flutter_/widget/rounded_container.dart';


import 'package:get/get.dart';

class ItemProduct extends StatelessWidget {
    final String? userEmail;

  final String? image;
  final String? name;
  final String? style;
  final String? description;
  final String? price;
  final List<String>? images;
  final List<String>? colors;
  final List<String>? sizes;

  const ItemProduct({
    this.image,
    this.name,
    this.style,
    this.price,
    super.key,
    this.description,
    this.images,
    this.colors,
    this.sizes,  this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetail(
          userEmail: "$userEmail",
              image: image,
              name: name,
              description: description,
              style: style,
              price: price,
              images: images ?? [],
              colors: colors ?? [],
              sizes: sizes ?? [],
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 190,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              RoundedContainer(
                height: 200,
                backgroundColor: Colors.white,
                child: Stack(
                  children: [
                    RoundedImage(
                      imageUrl: image ?? "assets/killshot2.png",
                      applyImageRadius: true,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircularIcon(
                        icon: Icons.favorite,
                        color: Colors.grey,
                        onPressed: () {
                          // Handle favorite logic here
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? "Nike KillShot 2",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      style ?? "Men's shoes",
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      price ?? "1000000",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
