import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/constants/key_constants.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/controlers/firebase_firestore_userdata_controler.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/models/user_model.dart';
import 'package:pchat/widgets/alfabate_color_avtar.dart';
import 'package:pchat/widgets/app_dilog.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';

class ProfileScreen extends StatelessWidget {
  final Rx<ChatAppUser> user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    print("profile Build");
    final isEditing = false.obs;
    final profileColor = user.value.profileColor.obs;

    return GetX<AuthControler>(
      builder: (controller) {
        String name = user.value.name;
        String info = user.value.info;
        String address = user.value.address;
        profileColor.value = user.value.profileColor;
        return WillPopScope(
          onWillPop: () async {
            if (isEditing.value) {
              isEditing.value = false;
              return false;
            }
            return true;
          },
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: AppText(
                  text: isEditing.value ? "Edite" : "Info",
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (isEditing.value) {
                          Get.find<FireStoreUserDataControler>().updateUserData(
                              uid: user.value.uid,
                              address: address,
                              info: info,
                              name: name,
                              profileColor: profileColor.value);
                        }

                        isEditing.value = !isEditing.value;
                      },
                      child: AppText(text: isEditing.value ? "Save" : "Edit")),
                ],
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: Get.width,
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (isEditing.value) {
                          profileColor.value = await showColorPickerDilog(
                              context: context,
                              curentColor: profileColor.value);
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Hero(
                              tag: HeroKeyConstants.profileAvtar,
                              child: AlphabateUserAvatar(
                                color: profileColor.value,
                                userName: user.value.name,
                                imageUrl: user.value.profileUrl,
                                redius: 100,
                              )),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: isEditing.value
                                ? const Icon(Icons.colorize_rounded)
                                : Container(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(text: "Name : "),
                        isEditing.value
                            ? Expanded(
                                child: AppTextField(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  height: 50,
                                  initialText: user.value.name,
                                  onChange: (value) => name = value,
                                ),
                              )
                            : AppText(
                                text: user.value.name,
                                fontSize: 20,
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(text: "Info : "),
                        isEditing.value
                            ? Expanded(
                                child: AppTextField(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  height: 50,
                                  initialText: user.value.info,
                                  onChange: (value) => info = value,
                                ),
                              )
                            : AppText(
                                text: user.value.info,
                                fontSize: 20,
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(text: "Address : "),
                        isEditing.value
                            ? Expanded(
                                child: AppTextField(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  height: 50,
                                  initialText: user.value.address,
                                  onChange: (value) => address = value,
                                ),
                              )
                            : AppText(
                                text: user.value.address,
                                fontSize: 20,
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                      text: "Email : ${user.value.email}",
                      fontSize: 20,
                    ),
                    user.value.uid == controller.currentUser!.value.uid
                        ? Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  goBack(context);
                                  controller.logOut();
                                },
                                child: controller.isLodding.value
                                    ? const CircularProgressIndicator()
                                    : const AppText(
                                        color: Colors.red,
                                        text: "Logout",
                                      ),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.deleteAcount();
                                },
                                child: controller.isLodding.value
                                    ? const CircularProgressIndicator()
                                    : const AppText(
                                        color: Colors.red,
                                        text: "Delete Acount",
                                      ),
                              ),
                            ],
                          )
                        : Container(),
                  ]),
                ),
              )),
        );
      },
    );
  }
}
