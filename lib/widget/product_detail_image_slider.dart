import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_/widget/circular_icon.dart';
import 'package:flutter_/widget/curved_edges_widget.dart';
import 'package:flutter_/widget/round_Iamge.dart';



class ProductImageSlider extends StatelessWidget {
  final List<String>? images;
  final String? image;

  const ProductImageSlider({
    super.key,
    this.images,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0 * 2),
                child: Center(
                  child: Image(
                    image: (image != null && image!.isNotEmpty)
                        ? FileImage(File(image!))
                        : const AssetImage('assets/killshot2.png') as ImageProvider,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 30,
              left: 20,
              child: SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images?.length ?? 0, // Get the number of images
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20), // Add spacing between images
                      child: RoundedImage(
                        imageUrl: images![index], // Use ! if you're sure it's not null
                        width: 80,
                        height: 80, // Set the height explicitly
                        border: Border.all(color: Colors.blueGrey),
                      ),
                    );
                  },
                ),
              ),
            ),
            AppBar(
              automaticallyImplyLeading: true,
              actions: const [
                CircularIcon(
                  icon: Icons.favorite,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
