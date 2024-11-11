
import 'package:flutter/material.dart';
import 'package:flutter_/widget/overall_product_rating.dart';
import 'package:flutter_/widget/rating_bar_indicator.dart';
import 'package:flutter_/widget/user_review_card.dart';



class ProductReviewScreen extends StatelessWidget {
  const ProductReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhận xét và đánh giá"),
        automaticallyImplyLeading: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Các bài đánh giá từ người mua"),

              SizedBox(
                height: 20,
              ),
              OverallProductRating(),

              RatingBarIndicatorWidget(rating: 3.5,),
              Text("(12,150)",style: TextStyle(),),
              SizedBox(height: 20,),

              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),

            ],
          ),
        ),
      ),
    );
  }
}


