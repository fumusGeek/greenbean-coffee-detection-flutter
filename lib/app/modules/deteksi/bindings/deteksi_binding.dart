import 'package:get/get.dart';

import '../controllers/deteksi_controller.dart';

class DeteksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeteksiController>(
      () => DeteksiController(),
    );
  }
}
