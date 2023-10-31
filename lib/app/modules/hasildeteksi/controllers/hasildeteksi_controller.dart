import 'dart:io';
// import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:get/get.dart';
// import 'package:tflite/tflite.dart';

class HasildeteksiController extends GetxController {
  //TODO: Implement HasildeteksiController

  final count = 0.obs;
  late final image;
  late final arguments;

  @override
  void onInit() async {
    super.onInit();
    arguments = Get.arguments;
    if (arguments != null && arguments['imagePath'] != null) {
      image = File(arguments['imagePath']);
    }
  }



  void increment() => count.value++;
}
