import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/deteksi_controller.dart';
import '../../home/views/home_view.dart';

class DeteksiView extends GetView<DeteksiController> {
  const DeteksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              controller.isLoading.value
                  ? CircularProgressIndicator()
                  : Container(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const AppHeader(),
                    const SizedBox(height: 24),
                    Container(
                      width: 375,
                      height: 400,
                      child: GetBuilder(
                        builder: (DeteksiController controller) {
                          return controller.images != null
                              ? Image.memory(controller.images!)
                              : const Placeholder();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    GetBuilder(
                      builder: (DeteksiController controller) =>
                          controller.images != null
                              ? Padding(
                                  padding: EdgeInsets.only(right: 190),
                                  child: Text(
                                    '${controller.mutu} dengan Total Defect ${controller.totalMutu}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ))
                              : Text(''),
                    ),
                    Text(
                      '(Coba cek kembali deskripsi dan hasil deteksi dengan fisik biji kopi, apakah sama atau tidak)',
                      style: TextStyle(color: Colors.red),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    GetBuilder(
                      builder: (DeteksiController controller) => Wrap(
                        children: List.generate(
                          controller.croppedImageList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.memory(
                                  controller.croppedImageList[index],
                                ),
                                Text('${controller.croppedImageLabel[index]} '),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    GetBuilder(
                      builder: (DeteksiController controller) => Wrap(
                        children: List.generate(
                          controller.deskripsiLabels.length,
                          (index) {
                            String label =
                                controller.labelForDescriptions[index];
                            String deskripsiLabels =
                                controller.deskripsiLabels[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Column(
                                children: [
                                  Text(
                                    'Nama Cacat: $label',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ), // Menampilkan key (label) dari dictionary
                                  Text(deskripsiLabels),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.brown.shade600,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Pilih Asal Gambar'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Kamera'),
                                        onPressed: () async {
                                          await controller.pickCamera();
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Penyimpanan'),
                                        onPressed: () async {
                                          await controller.pickImage();
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: GetBuilder(
                            builder: (DeteksiController controller) =>
                                controller.images != null
                                    ? Text(
                                        'Deteksi Lagi',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const Text(
                                        'Deteksi',
                                        style: TextStyle(color: Colors.white),
                                      ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: Icon(
                            Icons.info,
                            color: Colors.brown.shade600,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final items = [
                                  "Pastikan jarak kamera dengan objek yang akan dideteksi minimal 10 cm.",
                                  "Jarak yang disarankan antara kamera dengan objek adalah 15 cm.",
                                  "Pastikan kembali data yang berhasil di deteksi dengan melakukan pengecekan manual.",
                                  "Gunakan pencahayaan yang cukup, yang dimana jangan terlalu kontras.",
                                  "Disarankan menggunakan latar objek yang akan dideteksi bewarna putih.",
                                  "Beri jarak tiap-tiap objek yang akan dilakukan deteksi.",
                                  "Jika melakukan deteksi dengan jumlah besar, pastikan untuk melakukannya secara terpisah dan mengikuti instruksi nomor 6.",
                                ];
                                return AlertDialog(
                                  title: const Text(
                                    'Informasi',
                                    style: TextStyle(fontSize: 23),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          items.asMap().entries.map((entry) {
                                        final index = entry.key + 1;
                                        final text = entry.value;

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "$index.",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              Expanded(
                                                child: Text(
                                                  text,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
