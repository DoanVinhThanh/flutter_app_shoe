import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarIndicatorWidget extends StatelessWidget {
  final double rating;
  const RatingBarIndicatorWidget({
    super.key, required this.rating,
  });
  
  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemSize: 20,
      unratedColor: Colors.grey,
      itemBuilder: (_, __) => const Icon(
        Icons.star,
        color: Colors.blue,
      ),
    );
  }
}