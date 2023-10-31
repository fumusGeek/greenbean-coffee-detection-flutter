
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testhome/app/modules/home/views/home_view.dart';

import '../controllers/hasildeteksi_controller.dart';

class HasildeteksiView extends GetView<HasildeteksiController> {
  // final File image;
  final XFile? image;

  const HasildeteksiView({Key? key, required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        const AppHeader(),
        const SizedBox(height: 35),
        Expanded(
          child: Center(
            child: controller.image != null
                ? Image.file(controller.image)
                : const Text('No image'),
          ),
        ),
        const Expanded(
            child: Center(
          child: Text('Hasil Deteksi'),
        ))
      ],
    )));
  }
}
