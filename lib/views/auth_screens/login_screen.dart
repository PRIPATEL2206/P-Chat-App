import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/views/auth_screens/register_screen.dart';
import 'package:pchat/views/display_chat_screen.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("build login");
    String email = "";
    String password = "";
    AuthControler authControler = Get.find<AuthControler>();

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(5),
          width: Get.width,
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppText(
                fontSize: 30,
                text: "Login Now",
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                onChange: (value) => email = value,
                lableText: "Email",
                prefixIcon: const Icon(Icons.email),
              ),
              AppTextField(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                onChange: (value) => password = value,
                lableText: "Password",
                prefixIcon: const Icon(Icons.lock),
                ishide: true,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.snackbar("Info", "forgote password");
                    },
                    child: const AppText(
                      textAlign: TextAlign.end,
                      text: "Forgote Password ?",
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                  onPressed: () async {
                    print(email);
                    print(password);
                    final isUserLogin =
                        await authControler.loginUserWithEmailAndPassword(
                            email: email, password: password);
                    print(isUserLogin);
                    // Get.snackbar("info", "user login sussessfully");
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 3),
                      child: Obx(
                        () => authControler.isLodding.value
                            ? const CircularProgressIndicator(
                                color: Colors.green,
                              )
                            : const AppText(
                                fontSize: 20,
                                text: "Login",
                              ),
                      ))),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const AppText(text: "Don't have account?"),
                  TextButton(
                      onPressed: () {
                        replaceScreen(
                          context: context,
                          screen: const RegisterScreen(),
                        );
                      },
                      child: const AppText(
                        text: "Register Here.",
                        color: Colors.blue,
                      ))
                ],
              ),

              // TODO: remove this
              TextButton(
                  onPressed: () {
                    replaceScreen(
                        context: context, screen: const GroupDisplayScreen());
                  },
                  child: const AppText(
                    text: "home",
                  ))
            ],
          )),
    ));
  }
}
