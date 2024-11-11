import 'package:get/get.dart';

class HomeController extends GetxController{
  static HomeController get instance => Get.find();

  final carousalCurentindex = 0.obs;

  void updatePageIndicator(index){
    carousalCurentindex.value = index;
  }
}