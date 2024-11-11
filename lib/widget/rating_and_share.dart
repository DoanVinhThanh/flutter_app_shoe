import 'package:flutter/material.dart';

class RatingAndShare extends StatelessWidget {
  const RatingAndShare({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.star,color: Colors.amber,size: 24,),
            SizedBox(width: 10,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "5.0",style: TextStyle(fontWeight: FontWeight.bold,),
    
                  ),
                  TextSpan(text: "(200)"),
                ],
                ),
              ),
          ],
        ),
    
         Icon(Icons.share,size: 24,),
      ],
    );
  }
}
