import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/controlers/initi_app.dart';
import 'package:pchat/views/auth_screens/login_screen.dart';
import 'package:pchat/views/display_chat_screen.dart';
import 'package:pchat/widgets/app_future_builder.dart';

class LoddingScreen extends StatelessWidget {
  const LoddingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    print("loding buiild");
    return AppFutureBuilder(
        future: initApp(),
        builder: (isCompleted, data) {
          if (isCompleted) {
            return GetX<AuthControler>(
              builder: (controller) {
                print("build is login chack");
                if (controller.isUserLogin.value) {
                  print("going to group screen");
                  return const GroupDisplayScreen();
                }

                print("going to login screen");
                return const LoginScreen();
              },
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
