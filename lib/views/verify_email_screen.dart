import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/widgets/app_text.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authControler = Get.find<AuthControler>();
    authControler.sendEmailVerification();
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Expanded(
          child: AppText(
              maxLine: 4,
              text:
                  "You Are Not Verified yet we have send email for verification of your email "),
        ),
        Row(
          children: [
            const AppText(text: "Not get email ?"),
            TextButton(
                onPressed: () {
                  authControler.sendEmailVerification();
                },
                child: const AppText(
                  text: "resend email",
                ))
          ],
        )
      ]),
    );
  }
}
