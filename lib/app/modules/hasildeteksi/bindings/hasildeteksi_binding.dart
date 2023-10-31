import 'package:get/get.dart';

import '../controllers/hasildeteksi_controller.dart';

class HasildeteksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HasildeteksiController>(
      () => HasildeteksiController(),
    );
  }
}
