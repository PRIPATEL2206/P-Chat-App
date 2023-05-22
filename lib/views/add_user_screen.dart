import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/firebase_firestore_groupdata.dart';
import 'package:pchat/controlers/firebase_firestore_userdata_controler.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/models/group_model.dart';
import 'package:pchat/views/profile_screen.dart';
import 'package:pchat/widgets/app_dilog.dart';
import 'package:pchat/widgets/app_future_builder.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';
import 'package:pchat/widgets/user_tile.dart';

class AddUserScreen extends StatelessWidget {
  final Rx<ChatAppGroup> group;
  const AddUserScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    // print("add user Build");
    final userControler = Get.find<FireStoreUserDataControler>();
    final groupControler = Get.find<FireStoreGroupDataControler>();
    final searchText = "".obs;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () => goBack(context),
              child: const AppText(
                text: "Done",
              ))
        ],
        title: AppTextField(
          hintText: "Search",
          onChange: (value) => searchText.value = value,
        ),
      ),
      body: AppFutureBuilder(
          future: userControler.getAllUserFromDataBase(),
          builder: (isCompleted, data) {
            if (isCompleted && data != null) {
              return Obx(
                () {
                  final users = data
                      .where((element) =>
                          element.value.name.contains(searchText.value) ||
                          element.value.email.contains(searchText.value))
                      .toList();

                  // users.forEach((element) {
                  //   print(element.value.uid);
                  // });
                  // print(users);
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final isUserAdded =
                          group.value.members.contains(users[index].value.uid);
                      return GroupUserTile(
                          onTileTap: () => gotoScreen(
                              context: context,
                              screen: ProfileScreen(user: users[index])),
                          bgColor: users[index].value.profileColor,
                          trailing: group.value.admin != users[index].value.uid
                              ? IconButton(
                                  onPressed: () async {
                                    if (isUserAdded) {
                                      if (await showAppAlartDilog(context,
                                          "Do you want to delete ${users[index].value.name} from group ?")) {
                                        groupControler.deleteUserFromGroup(
                                            gid: group.value.gid,
                                            uid: users[index].value.uid);
                                      }
                                    } else if (await showAppAlartDilog(context,
                                        "Do you want to add ${users[index].value.name} in to group ?")) {
                                      groupControler.addUserInGroup(
                                          gid: group.value.gid,
                                          uid: users[index].value.uid);
                                    }
                                  },
                                  icon: isUserAdded
                                      ? const Icon(
                                          Icons.person_remove_outlined,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.person_add_alt_outlined,
                                          color: Colors.green,
                                        ))
                              : null,
                          indexKey: users[index].value.uid,
                          name: users[index].value.name,
                          dissception: users[index].value.info,
                          photoUrl: users[index].value.profileUrl);
                    },
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
