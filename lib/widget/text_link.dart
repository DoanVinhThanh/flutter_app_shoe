import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final Widget widget;
  const TextLink({super.key, required this.text, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget,
            ));
      },
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.blue, decoration: TextDecoration.underline,fontSize: 16,fontWeight: FontWeight.bold),
      ),
    );
  }
}
