import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/constants/key_constants.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/controlers/firebase_firestore_groupdata.dart';
import 'package:pchat/controlers/firebase_firestore_userdata_controler.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/models/group_model.dart';
import 'package:pchat/views/add_user_screen.dart';
import 'package:pchat/views/profile_screen.dart';
import 'package:pchat/widgets/alfabate_color_avtar.dart';
import 'package:pchat/widgets/app_dilog.dart';
import 'package:pchat/widgets/app_future_builder.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';
import 'package:pchat/widgets/user_tile.dart';

class GroupInfoScreen extends StatelessWidget {
  final Rx<ChatAppGroup> group;

  const GroupInfoScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    // print("group info build");
    final userControler = Get.find<FireStoreUserDataControler>();
    final groupControler = Get.find<FireStoreGroupDataControler>();
    final isEditing = false.obs;
    final groupIconColor = group.value.groupIconColor.obs;

    return Obx(
      () {
        String groupName = group.value.name;
        String groupDiscreption = group.value.discreption;
        groupIconColor.value = group.value.groupIconColor;

        final bool isUserAdmin = group.value.admin ==
            Get.find<AuthControler>().currentUser!.value.uid;
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
                actions: [
                  TextButton(
                      onPressed: () {
                        if (isEditing.value) {
                          groupControler.updateGroupData(
                            gid: group.value.gid,
                            name: groupName,
                            discription: groupDiscreption,
                            groupIconColor: groupIconColor.value,
                          );
                        }

                        isEditing.value = !isEditing.value;
                      },
                      child: AppText(
                        text: isEditing.value ? "Save" : "Edit",
                      )),
                  isUserAdmin
                      ? IconButton(
                          onPressed: () {
                            gotoScreen(
                                context: context,
                                screen: AddUserScreen(group: group));
                          },
                          icon: const Icon(Icons.person_add))
                      : Container(),
                ],
                title: AppText(
                  text: group.value.name,
                )),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (isEditing.value) {
                        groupIconColor.value = await showColorPickerDilog(
                            context: context,
                            curentColor: groupIconColor.value);
                      }
                      // print(groupIconColor.value);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(
                          () => Hero(
                            tag: HeroKeyConstants.groupAvtar,
                            child: AlphabateUserAvatar(
                              color: group.value.groupIconColor,
                              userName: group.value.name,
                              imageUrl: group.value.groupProfileUrl,
                              redius: 50,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
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
                      const AppText(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          text: "Group Name : "),
                      isEditing.value
                          ? Expanded(
                              child: AppTextField(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                height: 50,
                                initialText: group.value.name,
                                onChange: (value) => groupName = value,
                              ),
                            )
                          : AppText(
                              text: group.value.name,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppText(text: "Discreption : "),
                      isEditing.value
                          ? Expanded(
                              child: AppTextField(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                height: 50,
                                initialText: group.value.discreption,
                                onChange: (value) => groupDiscreption = value,
                              ),
                            )
                          : AppText(
                              text: group.value.discreption,
                              fontSize: 14,
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const AppText(text: "Group Members"),
                  Expanded(
                      child: AppFutureBuilder(
                          future: userControler
                              .getUsersFromDataBase(group.value.members),
                          builder: (isCompleted, data) {
                            if (isCompleted && data != null) {
                              final users = data;
                              return ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  return GroupUserTile(
                                    bgColor: users[index].value.profileColor,
                                    dissception: users[index].value.info,
                                    name: users[index].value.name,
                                    photoUrl: users[index].value.profileUrl,
                                    onTileTap: () => gotoScreen(
                                        context: context,
                                        screen:
                                            ProfileScreen(user: users[index])),
                                    indexKey: users[index].value.uid,
                                    trailing: isUserAdmin &&
                                            users[index].value.uid !=
                                                group.value.admin
                                        ? IconButton(
                                            onPressed: () => groupControler
                                                .deleteUserFromGroup(
                                                    gid: group.value.gid,
                                                    uid:
                                                        users[index].value.uid),
                                            icon: const Icon(
                                              Icons.person_remove_outlined,
                                              color: Colors.red,
                                            ))
                                        : null,
                                  );
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }))
                ]),
          ),
        );
      },
    );
  }
}
