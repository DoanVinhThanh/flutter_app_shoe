import 'package:flutter/material.dart';
import 'package:flutter_/widget/progess_indicator_and_rating.dart';

class OverallProductRating extends StatelessWidget {
  const OverallProductRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "4.8",
            style: TextStyle(fontSize: 42),
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              RatingProcessIndicator(text: "5",value: 1.0,),
              RatingProcessIndicator(text: "4",value: 0.8,),
              RatingProcessIndicator(text: "3",value: 0.6,),
              RatingProcessIndicator(text: "2",value: 0.4,),
              RatingProcessIndicator(text: "1",value: 0.2,),
    
            ],
          ),
        ),
      ],
    );
  }
}
