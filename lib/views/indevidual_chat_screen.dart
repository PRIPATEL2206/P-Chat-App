import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/controlers/firebase_firestore_chat_controler.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/models/group_model.dart';
import 'package:pchat/views/group_info_page.dart';
import 'package:pchat/widgets/alfabate_color_avtar.dart';
import 'package:pchat/widgets/app_future_builder.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';

class ChatScreen extends StatelessWidget {
  final int index;
  final Rx<ChatAppGroup> group;
  const ChatScreen({
    super.key,
    required this.index,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    // print("Chat Screen build");
    final chatControler = Get.find<FireStoreChatControler>();
    String chatText = "";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: InkWell(
          onTap: () => gotoScreen(
            context: context,
            screen: GroupInfoScreen(
              group: group,
            ),
          ),
          child: Row(
            children: [
              Hero(
                tag: group.value.gid,
                child: AlphabateUserAvatar(
                    color: group.value.groupIconColor,
                    userName: group.value.name,
                    imageUrl: group.value.groupProfileUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              AppText(text: group.value.name),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AppFutureBuilder(
                  future: chatControler.getChatsOfGroup(group.value.gid),
                  builder: (isCompleted, data) {
                    if (isCompleted) {
                      if (data != null) {
                        final chats = data;
                        return GetX<FireStoreChatControler>(
                          builder: (controller) {
                            String prewusDate = "";
                            final todayDate =
                                "${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}";
                            return ListView.builder(
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                bool isDateShow = false;
                                if (prewusDate !=
                                        "${chats[index].dateTime.day} / ${chats[index].dateTime.month} / ${chats[index].dateTime.year}" &&
                                    prewusDate != "Today") {
                                  prewusDate =
                                      "${chats[index].dateTime.day} / ${chats[index].dateTime.month} / ${chats[index].dateTime.year}";
                                  if (prewusDate == todayDate) {
                                    prewusDate = "Today";
                                  }
                                  isDateShow = true;
                                }
                                final isSendByCurrentUser =
                                    Get.find<AuthControler>()
                                            .currentUser!
                                            .value
                                            .uid ==
                                        chats[index].sendBy;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 3),
                                  child: Column(
                                    children: [
                                      isDateShow
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: AppText(text: prewusDate),
                                            )
                                          : Container(),
                                      Row(
                                        mainAxisAlignment: isSendByCurrentUser
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: isSendByCurrentUser
                                                    ? Colors.teal
                                                    : Colors.black54,
                                                borderRadius:
                                                    isSendByCurrentUser
                                                        ? BorderRadius.circular(
                                                                10)
                                                            .copyWith(
                                                                topRight:
                                                                    Radius.zero)
                                                        : BorderRadius.circular(
                                                                10)
                                                            .copyWith(
                                                                topLeft: Radius
                                                                    .zero)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  isSendByCurrentUser
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                              children: [
                                                AppText(
                                                  text: chats[index].message,
                                                  fontSize: 20,
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                AppText(
                                                    fontSize: 12,
                                                    textAlign: TextAlign.end,
                                                    text:
                                                        "${chats[index].dateTime.hour} : ${chats[index].dateTime.minute}")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                      return const Center(
                        child: AppText(
                          text: "No Chat yet",
                          color: Colors.grey,
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: AppTextField(
                    inputAction: TextInputAction.send,
                    // margin: EdgeInsets.zero,
                    onChange: (value) => chatText = value,
                    hintText: "Massage",
                    height: 50,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      // print(chatText.text);
                      chatControler.sendMessage(
                        groupId: group.value.gid,
                        message: chatText,
                        sendBy:
                            Get.find<AuthControler>().currentUser!.value.uid,
                      );
                    },
                    icon: const Icon(size: 35, Icons.send_rounded)),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
