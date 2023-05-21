import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/constants/key_constants.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/controlers/firebase_firestore_groupdata.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/views/indevidual_chat_screen.dart';
import 'package:pchat/views/profile_screen.dart';
import 'package:pchat/widgets/alfabate_color_avtar.dart';
import 'package:pchat/widgets/app_dilog.dart';
import 'package:pchat/widgets/app_future_builder.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';
import 'package:pchat/widgets/user_tile.dart';

class GroupDisplayScreen extends StatelessWidget {
  const GroupDisplayScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // print("display chat build");
    AuthControler authControler = Get.find<AuthControler>();
    final groupControler = Get.find<FireStoreGroupDataControler>();
    final isSearch = false.obs;
    final searchText = "".obs;

    return WillPopScope(
      onWillPop: () async {
        if (isSearch.value) {
          isSearch.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              Obx(
                () => isSearch.value
                    ? Container()
                    : IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => isSearch.value = !isSearch.value,
                      ),
              )
            ],
            title: Obx(() => isSearch.value
                ? AppTextField(
                    hintText: "Search",
                    onChange: (value) => searchText.value = value,
                  )
                : Row(
                    children: [
                      InkWell(
                        onTap: () => gotoScreen(
                            context: context,
                            screen: ProfileScreen(
                              user: authControler.currentUser!,
                            )),
                        child: Hero(
                            tag: HeroKeyConstants.profileAvtar,
                            child: AlphabateUserAvatar(
                              color:
                                  authControler.currentUser!.value.profileColor,
                              imageUrl:
                                  authControler.currentUser?.value.profileUrl ??
                                      "",
                              userName: authControler.currentUser!.value.name,
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const AppText(text: "P-Chat"),
                    ],
                  )),
          ),
          body: AppFutureBuilder(
              future: groupControler
                  .getRXAllGroupsOfUser(authControler.currentUser!),
              builder: (isCompleted, data) {
                if (isCompleted) {
                  if (data != null) {
                    return GetX<FireStoreGroupDataControler>(
                      builder: (controller) {
                        final groups = data
                            .where((element) =>
                                element.value.name.contains(searchText))
                            .toList()
                            .obs;
                        return ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            return GroupUserTile(
                              bgColor: groups[index].value.groupIconColor,
                              dissception: groups[index].value.discreption,
                              name: groups[index].value.name,
                              photoUrl: groups[index].value.groupProfileUrl,
                              indexKey: groups[index].value.gid,
                              onTileTap: () {
                                gotoScreen(
                                    context: context,
                                    screen: ChatScreen(
                                      group: groups[index],
                                      index: index,
                                    ));
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(
                    child: AppText(
                      text: "your are not added in any group",
                      fontSize: 20,
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final groupName = await showAddGroupDilog(context);
              print("group name = $groupName");
              if (groupName.isNotEmpty) {
                groupControler.createGroup(
                  groupName: groupName,
                  admin: authControler.currentUser!.value.uid,
                );
              }
              // gotoScreen(context: context, screen:  SearchScreen(
              // ));
            },
            child: const Icon(Icons.group_add),
          )),
    );
  }
}
