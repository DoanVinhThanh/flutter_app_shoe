import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext,int) itemBuilder;
  const GridLayout({
    super.key, required this.itemCount, this.mainAxisExtent = 314, required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 40,
            crossAxisSpacing: 10,
            mainAxisExtent: 330,
            ),
        itemBuilder: itemBuilder,);
  }
}
