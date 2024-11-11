import 'package:flutter/material.dart';

class RoundedImageBanner extends StatelessWidget {
  const RoundedImageBanner({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.onPressed,
    this.borderRadius = 16,
  });

  final double? width, height;
  final String imageUrl; // Can be a file path or an asset path
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
        child: imageUrl.isNotEmpty // Check if imageUrl is not empty
            ? (imageUrl.startsWith('http') // Check if it's a network image
                ? Image.network(imageUrl, fit: fit!)
                : Image.asset(imageUrl, fit: fit!)) // Load from assets
            : Image.asset('assets/killshot2.png', fit: fit!), // Default asset if empty
      ),
    ),
  );
}

}
