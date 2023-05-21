import 'package:flutter/animation.dart';
import 'package:pchat/constants/key_constants.dart';

class ChatAppGroup {
  final String gid;
  final String name;
  final String discreption;
  final String admin;
  final Color groupIconColor;
  final String groupProfileUrl;
  final List<String> members;
  // final List<Chat> chats;

  ChatAppGroup({
    required this.gid,
    required this.name,
    required this.discreption,
    required this.admin,
    required this.groupIconColor,
    required this.groupProfileUrl,
    required this.members,
    // required this.chats,
  });

  ChatAppGroup.fromJson(Map<String, dynamic> jsonData)
      : gid = jsonData[GroupJsonKey.gid],
        name = jsonData[GroupJsonKey.name],
        discreption = jsonData[GroupJsonKey.discreption],
        admin = jsonData[GroupJsonKey.admin],
        groupIconColor = Color(jsonData[GroupJsonKey.groupIconColor]),
        groupProfileUrl = jsonData[GroupJsonKey.groupProfileUrl],
        members = (jsonData[GroupJsonKey.members] as List)
            .map((e) => e.toString())
            .toList()
  // ,chats = (jsonData[GroupJsonKey.chats] as List)
  //     .map((e) => Chat.fromJson(e))
  //     .toList()
  ;

  Map<String, dynamic> toJson() => {
        GroupJsonKey.gid: gid,
        GroupJsonKey.name: name,
        GroupJsonKey.discreption: discreption,
        GroupJsonKey.admin: admin,
        GroupJsonKey.groupIconColor: groupIconColor.value,
        GroupJsonKey.groupProfileUrl: groupProfileUrl,
        GroupJsonKey.members: members,
        // GroupJsonKey.chats: chats.map((e) => e.toJson()).toList(),
      };
}
