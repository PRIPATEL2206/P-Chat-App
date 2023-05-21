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
import 'package:pchat/widgets/app_future_builder.dart';
import 'package:pchat/widgets/app_text.dart';
import 'package:pchat/widgets/user_tile.dart';

class GroupInfoScreen extends StatelessWidget {
  final Rx<ChatAppGroup> group;

  const GroupInfoScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    print("group info build");
    final userControler = Get.find<FireStoreUserDataControler>();
    final groupControler = Get.find<FireStoreGroupDataControler>();
    return Obx(
      () {
        final bool isUserAdmin = group.value.admin ==
            Get.find<AuthControler>().currentUser!.value.uid;
        return Scaffold(
          appBar: AppBar(
              actions: [
                isUserAdmin
                    ? IconButton(
                        onPressed: () {
                          gotoScreen(
                              context: context,
                              screen: AddUserScreen(group: group));
                        },
                        icon: const Icon(Icons.person_add))
                    : Container()
              ],
              title: AppText(
                text: group.value.name,
              )),
          body: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Hero(
              tag: HeroKeyConstants.groupAvtar,
              child: AlphabateUserAvatar(
                color: group.value.groupIconColor,
                userName: group.value.name,
                imageUrl: group.value.groupProfileUrl,
                redius: 50,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppText(
              fontSize: 20,
              text: group.value.name,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              fontSize: 14,
              text: group.value.discreption,
              color: Colors.grey,
            ),
            AppText(
              fontSize: 20,
              text: "Admin: ${group.value.admin}",
              fontWeight: FontWeight.bold,
            ),
            const AppText(text: "Group Members"),
            Expanded(
                child: AppFutureBuilder(
                    future:
                        userControler.getUsersFromDataBase(group.value.members),
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
                                  screen: ProfileScreen(user: users[index])),
                              indexKey: users[index].value.uid,
                              trailing: isUserAdmin
                                  ? IconButton(
                                      onPressed: () =>
                                          groupControler.deleteUserFromGroup(
                                              gid: group.value.gid,
                                              uid: users[index].value.uid),
                                      icon: const Icon(
                                        Icons.delete,
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
        );
      },
    );
  }
}
