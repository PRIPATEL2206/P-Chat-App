import 'package:flutter/animation.dart';
import 'package:pchat/constants/key_constants.dart';

class ChatAppUser {
  final String uid;
  final String name;
  final String info;
  final String email;
  final String address;
  final Color profileColor;
  final String profileUrl;
  final List<String> groupUserAdded;

  ChatAppUser({
    required this.uid,
    required this.name,
    required this.info,
    required this.email,
    required this.address,
    required this.profileColor,
    required this.profileUrl,
    required this.groupUserAdded,
  });

  ChatAppUser.fromjson(Map<String, dynamic> json)
      : uid = json[UserJsonKey.uid],
        name = json[UserJsonKey.name],
        info = json[UserJsonKey.info],
        email = json[UserJsonKey.email],
        address = json[UserJsonKey.address],
        profileColor = Color(json[UserJsonKey.profileColor]),
        profileUrl = json[UserJsonKey.profileUrl],
        groupUserAdded = (json[UserJsonKey.groupUserAdded] as List)
            .map((e) => e.toString())
            .toList();

  Map<String, dynamic> toJson() => {
        UserJsonKey.uid: uid,
        UserJsonKey.name: name,
        UserJsonKey.info: info,
        UserJsonKey.email: email,
        UserJsonKey.address: address,
        UserJsonKey.profileColor: profileColor.value,
        UserJsonKey.profileUrl: profileUrl,
        UserJsonKey.groupUserAdded: groupUserAdded,
      };
}
