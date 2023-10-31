import 'package:get/get.dart';

import '../controllers/infotable_controller.dart';

class InfotableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfotableController>(
      () => InfotableController(),
    );
  }
}
