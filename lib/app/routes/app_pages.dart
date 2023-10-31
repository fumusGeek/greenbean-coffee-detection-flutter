import 'package:get/get.dart';

import '../modules/deteksi/bindings/deteksi_binding.dart';
import '../modules/deteksi/views/deteksi_view.dart';
import '../modules/hasildeteksi/bindings/hasildeteksi_binding.dart';
import '../modules/hasildeteksi/views/hasildeteksi_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info/bindings/info_binding.dart';
import '../modules/info/views/info_view.dart';
import '../modules/infotable/bindings/infotable_binding.dart';
import '../modules/infotable/views/infotable_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DETEKSI,
      page: () => const DeteksiView(),
      binding: DeteksiBinding(),
    ),
    GetPage(
      name: _Paths.INFO,
      page: () => const InfoView(),
      binding: InfoBinding(),
    ),
    GetPage(
      name: _Paths.INFOTABLE,
      page: () => const InfotableView(),
      binding: InfotableBinding(),
    ),
    GetPage(
      name: _Paths.HASILDETEKSI,
      page: () => const HasildeteksiView(
        image: null,
      ),
      binding: HasildeteksiBinding(),
    ),
  ];
}
