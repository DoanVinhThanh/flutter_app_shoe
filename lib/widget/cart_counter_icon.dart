import 'package:flutter/material.dart';


class CartCounterIcon extends StatelessWidget {
  final int? quantity ;
  final VoidCallback? onPressed;
  final Color? iconColor,counterBgColor,counterTextColor;
  const CartCounterIcon({
    super.key,  this.onPressed, this.iconColor, this.counterBgColor, this.counterTextColor, this.quantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
            onPressed: onPressed,
            icon:  Icon(
              Icons.shopping_bag_outlined,
              color: iconColor,
              size: 35,
            )),
        Positioned(
          right: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: counterBgColor?.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child:  Center(
              child: Text(
                "$quantity",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: counterTextColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
