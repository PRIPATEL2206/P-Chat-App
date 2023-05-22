import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/views/loding_screen.dart';
import 'package:pchat/widgets/app_text.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authControler = Get.find<AuthControler>();
    // authControler.sendEmailVerification();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const AppText(
                maxLine: 4,
                fontSize: 20,
                text: "You Are Not Verified your email yet  "),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => authControler.logOut(),
                    child: const AppText(
                      text: "Go to Login Page",
                    )),
                ElevatedButton(
                    onPressed: () {
                      authControler.sendEmailVerification();
                      Future.delayed(const Duration(seconds: 10)).then(
                          (value) => replaceScreen(
                              context: context, screen: const LoddingScreen()));
                    },
                    child: const AppText(
                      text: "Send Code",
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }
}
