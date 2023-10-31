import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/infotable_controller.dart';
import '../../home/views/home_view.dart';

class InfotableView extends GetView<InfotableController> {
  const InfotableView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      Get.toNamed('/info');
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
            Container(
              child: const Text(
                "Defect Biji Kopi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: ListView.builder(
                    itemCount: DefectsData.defectsData.length,
                    itemBuilder: (context, index) {
                      final defect = DefectsData.defectsData[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                defect.defect,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                defect.nilaiCacat,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "Mutu Biji Kopi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: ListView.builder(
                    itemCount: MutuBiji.mutuBiji.length,
                    itemBuilder: (context, index) {
                      final mutu = MutuBiji.mutuBiji[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                mutu.mutu,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                mutu.nilaiMutu,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MutuBiji {
  final String mutu;
  final String nilaiMutu;

  MutuBiji({required this.mutu, required this.nilaiMutu});

  static List<MutuBiji> mutuBiji = [
    MutuBiji(mutu: 'Mutu 1', nilaiMutu: "11"),
    MutuBiji(mutu: 'Mutu 2', nilaiMutu: "12 - 25"),
    MutuBiji(mutu: 'Mutu 3', nilaiMutu: "16 - 24"),
    MutuBiji(mutu: 'Mutu 4a', nilaiMutu: "45 - 60"),
    MutuBiji(mutu: 'Mutu 4b', nilaiMutu: "61 - 80"),
    MutuBiji(mutu: 'Mutu 5', nilaiMutu: "81 - 150"),
    MutuBiji(mutu: 'Mutu 6', nilaiMutu: "151 - 225"),
  ];
}

class DefectsData {
  final String defect;
  final String nilaiCacat;

  DefectsData({required this.defect, required this.nilaiCacat});

  static List<DefectsData> defectsData = [
    DefectsData(defect: 'Biji Hitam', nilaiCacat: '1'),
    DefectsData(defect: 'Biji hitam sebagian', nilaiCacat: '1/2'),
    DefectsData(defect: 'Biji hitam pecah', nilaiCacat: '1/2'),
    DefectsData(defect: 'Kopi gelondong', nilaiCacat: '1'),
    DefectsData(defect: 'Biji coklat', nilaiCacat: '1/4'),
    DefectsData(defect: 'Kulit kopi ukuran besar', nilaiCacat: '1'),
    DefectsData(defect: 'Kulit kopi ukuran sedang', nilaiCacat: '1/2'),
    DefectsData(defect: 'Kulit kopi ukuran kecil', nilaiCacat: '1/5'),
    DefectsData(defect: 'Biji berkulit tanduk', nilaiCacat: '1/2'),
    DefectsData(defect: 'Kulit tanduk ukuran besar', nilaiCacat: '1/2'),
    DefectsData(defect: 'Kulit tanduk ukuran sedang', nilaiCacat: '1/5'),
    DefectsData(defect: 'Kulit tanduk ukuran kecil', nilaiCacat: '1/10'),
    DefectsData(defect: 'Biji pecah', nilaiCacat: '1/5'),
    DefectsData(defect: 'Biji muda', nilaiCacat: '1/5'),
    DefectsData(defect: 'Biji berlubang satu', nilaiCacat: '1/10'),
    DefectsData(defect: 'Biji berlubang lebih dari satu', nilaiCacat: '1/5'),
    DefectsData(defect: 'Biji bertutul-tutul', nilaiCacat: '1/10'),
    DefectsData(
        defect: 'Ranting, tanah atau batu berukuran besar', nilaiCacat: '5'),
    DefectsData(
        defect: 'Ranting, tanah atau batu berukuran sedang', nilaiCacat: '2'),
    DefectsData(
        defect: 'Ranting, tanah atau batu berukuran kecil', nilaiCacat: '1'),
  ];
}
