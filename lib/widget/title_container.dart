import 'package:flutter/material.dart';

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    super.key,
    required this.title,
    this.colortitlebutton,
    this.buttonTitle = "Xem tất cả",
    this.showActionButton = false,
    this.onPressed,
    this.colortitle,
  });
  final String title;
  final Color? colortitlebutton, colortitle;
  final String buttonTitle;
  final bool showActionButton;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Đảm bảo căn trái toàn bộ nội dung
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colortitle,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (showActionButton)
            GestureDetector(
                onTap: onPressed,
                child: Text(
                  buttonTitle,
                  style: TextStyle(fontSize: 16, color: colortitlebutton),
                ))
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
