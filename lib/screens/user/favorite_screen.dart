import 'package:flutter/material.dart';
import 'package:flutter_/widget/app_bar.dart';
import 'package:flutter_/widget/grid_layout.dart';
import 'package:flutter_/widget/item_product.dart';



class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(
              isButtonBack: false,
              title: "Yêu thích",
              icon: Icons.add,
              isIcon: true,
              isQuantity: false,
              onIconPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
            GridLayout(itemCount: 6, itemBuilder: (context, index) =>  ItemProduct(),),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
