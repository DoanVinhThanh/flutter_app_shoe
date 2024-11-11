import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String title, image, subtitle;
  final VoidCallback onPressed;
  const SuccessScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.subtitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 300),
        child: Column(children: [
          Image(image: AssetImage(image),width: 100,),
          const SizedBox(height: 20,),
          Text(title,textAlign: TextAlign.center,),
          const SizedBox(height: 20,),
          Text(subtitle,textAlign: TextAlign.center,),
          const SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: onPressed,
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)), child: const Text("Continue",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
            ),
          ),

        ],),),

      ),
    );
  }
}
