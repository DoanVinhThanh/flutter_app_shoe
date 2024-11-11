import 'package:flutter/material.dart';
import 'package:flutter_/screens/user/search_screen.dart';
import 'package:get/get.dart';

class SearchContainer extends StatelessWidget {
  final String email;
  final ValueChanged<String> onSearchSubmitted;

  const SearchContainer({super.key, required this.onSearchSubmitted, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController keywordController = TextEditingController();

    return Container(
      height: 60,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: keywordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, size: 30, color: Colors.black),
                hintText: 'Tìm kiếm....',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
              ),

            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 20,
              height: 60,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 21, 105, 241),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  if (keywordController.text.isNotEmpty) {
                    onSearchSubmitted(keywordController.text);
                    Get.to(() => SearchScreen(userEmail: email,keyword: keywordController.text,));
                  }
                },
                icon: const Icon(Icons.arrow_forward, size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
