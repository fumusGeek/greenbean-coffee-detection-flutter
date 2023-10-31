import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //header
            const AppHeader(),
            //main menu
            Expanded(
              flex: 3,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.camera,
                            size: 60,
                            color: Colors.brown.shade600,
                          ),
                          onPressed: () {
                            //deteksi
                            Get.toNamed('/deteksi');
                          },
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            'Deteksi Grade',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.info_outline_rounded,
                              size: 70, color: Colors.brown.shade600),
                          onPressed: () {
                            //deteksi
                            Get.toNamed('/info');
                          },
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            'Informasi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  const AppHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.brown.shade600,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.coffee_sharp,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
