import 'package:flutter/material.dart';
class TitleListCustom extends StatelessWidget {
  final String title ;
  final String content ;
  final IconData icon;
  final Widget page;
  const TitleListCustom( {super.key, required this.title, required this.content, required this.icon, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      icon,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
  }
}