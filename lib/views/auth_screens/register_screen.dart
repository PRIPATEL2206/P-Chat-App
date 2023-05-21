import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/views/auth_screens/login_screen.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';

class RegisterScreen extends StatelessWidget {
  //   String? email;

  //  String? userName ;

  // String? password ;

  // String? conformPassword ;

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("build register");
    String email = "";
    String userName = "";
    String password = "";
    String conformPassword = "";
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
                text: "Register Now",
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                onChange: (value) => userName = value,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                lableText: "User Name",
                prefixIcon: const Icon(Icons.person),
              ),
              AppTextField(
                onChange: (value) => email = value,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                lableText: "Email",
                prefixIcon: const Icon(Icons.email),
              ),
              AppTextField(
                onChange: (value) => password = value,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                lableText: "Password",
                prefixIcon: const Icon(Icons.lock),
                ishide: true,
              ),
              AppTextField(
                onChange: (value) => conformPassword = value,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                lableText: "Conform Password",
                prefixIcon: const Icon(Icons.lock),
                ishide: true,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  print(email);
                  print(password);
                  print(userName);
                  if (password == conformPassword) {
                    final isSucsses =
                        await authControler.registerUserWithEmailAndPassword(
                            email: email,
                            password: password,
                            userName: userName);
                    print("isSucsess ${isSucsses.toString()}");
                    if (isSucsses) {
                      Get.snackbar("info", "register sucsessfully");
                      replaceScreen(
                          context: context, screen: const LoginScreen());
                    }
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: Obx(
                    (() => authControler.isLodding.value
                        ? const CircularProgressIndicator(
                            color: Colors.green,
                          )
                        : const AppText(
                            fontSize: 20,
                            text: "Register",
                          )),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const AppText(text: "Alrady have account ?"),
                  TextButton(
                    onPressed: () {
                      replaceScreen(
                        context: context,
                        screen: const LoginScreen(),
                      );
                    },
                    child: const AppText(
                      text: "Login Here.",
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          )),
    ));
  }
}
