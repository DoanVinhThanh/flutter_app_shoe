import 'package:flutter/material.dart';
import 'package:flutter_/widget/rounded_container.dart';

class DiscountCode extends StatelessWidget {
  const DiscountCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      showBorder: true,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.only(top: 8,bottom:8 ,right: 8,left: 16),
      child: Row(
        children: [
          Flexible(child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Nhập mã giảm giá vào đây',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),),
          SizedBox(
            width: 120,
            child: ElevatedButton(onPressed: () {
              
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue)
            ), child: const Text("Áp dụng",style: TextStyle(color: Colors.white),),),
          ),
        ],
      ),
    );
  }
}
