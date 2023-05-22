import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoddingSplashScreen extends StatelessWidget {
  const LoddingSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icon/icon.png", width: Get.width * 0.5),
          const SizedBox(
            height: 30,
          ),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
