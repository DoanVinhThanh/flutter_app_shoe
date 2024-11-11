import 'dart:io';

import 'package:flutter/material.dart';


class ListCategories extends StatelessWidget {
  final String userEmail;

  final String image;
  final String textCategory;
  final void Function()? onTap;
  const ListCategories({
    super.key, required this.image, required this.textCategory, this.onTap, required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: CircleAvatar(
                backgroundImage: FileImage(File(image)),

              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Text(textCategory,maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
