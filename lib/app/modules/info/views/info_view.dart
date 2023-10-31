import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/info_controller.dart';
import '../../home/views/home_view.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.toNamed('/home');
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.toNamed('/infotable');
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/coffee.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Sistem penilaian mutu biji kopi biasanya mengacu pada sejumlah kriteria, antara lain, origin, ekosistem, varietas, cara panen, cara pengolahan (pascapanen), ukuran biji, densitas biji, nilai cacat, dan rasa. Setiap negara penghasil kopi memiliki cara pandang tersendiri dalam menetapkan sebagian atau seluruh kriteria tersebut. Indonesia telah menerapkan baku mutu biji kopi sejak tahun 1990 berdasarkan uji fisik atas jumlah defect. Standar mutu ini telah mengalami beberapa kali direvisi dan saat ini telah masuk dalam Standar Nasional Indonesia (SNI) nomor 01-2907-2008. Standar kualitas direvisi untuk memenuhi tuntutan pasar nasional dan global yang terus berkembang. Oleh karena itu, kriteria mutu dalam SNI harus selalu mengacu pada persyaratan internasional yang dikeluarkan oleh ICO (International Coffee Organization). Klasifikasi mutu biji kopi regular ditentukan berdasarkan temuan spesies dan jumlah biji cacat dalam sampel dihitung menurut Peraturan SNI No. 01-2907-2008. Jumlah nilai cacat yang terakumulasi pada setiap sampel menentukan penilaian kualiats mutu biji kopi yang diuji',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
