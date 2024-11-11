import 'package:flutter/material.dart';
import 'package:flutter_/widget/cart_counter_icon.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final bool isSearchContainer;
  final IconData? icon;
  final bool isQuantity;
  final VoidCallback? onIconPressed;
  final bool isButton;
  final bool isIcon;
  final bool isButtonBack;

  const AppBarWidget(
      {super.key,
      required this.title,
      this.isSearchContainer = false,
      required this.icon,
      this.isQuantity = false,
      this.onIconPressed,
      this.isButton = false,
      this.isIcon = false,
      this.isButtonBack = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade500,
            Colors.blue.shade400,
          ],
          begin: Alignment.topCenter,
        ),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                isButtonBack
                    ? IconButton(
                        onPressed: onIconPressed,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ))
                    : const SizedBox(),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                 CartCounterIcon(
                  iconColor: Colors.white,
                  counterBgColor: Colors.black,
                  counterTextColor: Colors.white,
                  onPressed: onIconPressed,
                ),
              ],
            ),
            isSearchContainer
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            isSearchContainer ? const SizedBox() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
