import 'package:flutter/material.dart';

class RatingProcessIndicator extends StatelessWidget {
  final String text;
  final double value;
  const RatingProcessIndicator({
    super.key, required this.text, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1,child: Text(text)),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: Colors.grey,
              valueColor:
                  const AlwaysStoppedAnimation(Colors.blue),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}
