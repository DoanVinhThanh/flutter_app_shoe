import 'package:flutter/material.dart';
import 'package:flutter_/widget/rating_bar_indicator.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/cat.png"),
                ),
                SizedBox(
                  width: 20,
                ),
                Text("data",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          children: [
            RatingBarIndicatorWidget(rating: 4),
            SizedBox(
              width: 10,
            ),
            Text("01 Nov, 2024"),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const ReadMoreText(
          'ámdlkasdlkasml kdsamlkmlkmlkam lkasmdlksamldmsa ldmalksmdkla dmlkasmdlkasml dmsaklmdlksamlk dlkasmdlkaml skdmkalsmdkmasldm dmlkasmdlkasmdmlak smdlamldmsa ',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: "Rút gọn",
          trimCollapsedText: "Hiển thị",
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20,),
        const Divider(),
      ],
    );
  }
}
