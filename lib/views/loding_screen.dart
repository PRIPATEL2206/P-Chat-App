import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/controlers/initi_app.dart';
import 'package:pchat/views/auth_screens/login_screen.dart';
import 'package:pchat/views/display_chat_screen.dart';
import 'package:pchat/views/loding_splash_screen.dart';
import 'package:pchat/views/verify_email_screen.dart';
import 'package:pchat/widgets/app_future_builder.dart';

class LoddingScreen extends StatelessWidget {
  const LoddingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // print("loding buiild");
    return AppFutureBuilder(
        future: initApp(),
        builder: (isCompleted, data) {
          if (isCompleted) {
            return GetX<AuthControler>(
              builder: (controller) {
                if (controller.isLodding.value) {
                  return const LoddingSplashScreen();
                }

                // print(
                //     "build is login chack ${controller.isEmailVerified} ${controller.isUserLogin}");
                if (!controller.isUserLogin.value) {
                  // print("going to login screen");
                  return const LoginScreen();
                }
                if (!controller.isEmailVerified.value) {
                  return const EmailVerificationScreen();
                }

                // print("going to group screen");
                return const GroupDisplayScreen();
              },
            );
          }
          return const LoddingSplashScreen();
        });
  }
}
