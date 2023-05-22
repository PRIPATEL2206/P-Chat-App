import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/constants/firebase_constants.dart';
import 'package:pchat/constants/key_constants.dart';
import 'package:pchat/controlers/firebase_firestore_userdata_controler.dart';
import 'package:pchat/helper/stream_lisiner_helper.dart';
import 'package:pchat/models/group_model.dart';
import 'package:pchat/models/user_model.dart';

class FireStoreGroupDataControler extends GetxController {
  final FireStoreUserDataControler _userDataControler;

  FireStoreGroupDataControler(this._userDataControler);

  @override
  Future<void> onClose() async {
    super.onClose();
    StreamLisinerHelper.closeGroupSubscription();
  }

  Future<RxList<Rx<ChatAppGroup>>> getRXAllGroupsOfUser(
      Rx<ChatAppUser> user) async {
    final RxList<Rx<ChatAppGroup>> groups = <Rx<ChatAppGroup>>[].obs;
    getAllGroupsOfUser(user.value).then((value) => groups.value = value);

    user.stream.listen((newUser) async {
      groups.value = await getAllGroupsOfUser(newUser);
    }, cancelOnError: true);

    return groups;
  }

  Future<List<Rx<ChatAppGroup>>> getAllGroupsOfUser(ChatAppUser user) async {
    final List<Rx<ChatAppGroup>> groups = [];

    for (var group in user.groupUserAdded) {
      final cGroup = await getGroup(group);

      if (cGroup != null) {
        groups.add(cGroup);
      }
    }
    // print("getAllUser");
    // print(groups);
    return groups;
  }

  Future<Rx<ChatAppGroup>?> getGroup(String groupId) async {
    final groupRef = await getGroupDocumentRef(groupId);
    if (groupRef != null) {
      final group = Rx(
        ChatAppGroup.fromJson(
          await groupRef.get().then((value) => value.data()!),
        ),
      );
      final sub = groupRef.snapshots().listen((event) {
        group.value = ChatAppGroup.fromJson(event.data()!);
      });
      StreamLisinerHelper.addGroupSubscription(sub);
      return group;
    }
    return null;
  }

  Future<bool> isGroupExist(String groupId) async {
    if (groupId.isNotEmpty) {
      return await FirebaseFirestore.instance
          .collection(FireBaseConstants.groupCollection)
          .doc(groupId)
          .get()
          .then((value) => value.exists);
    }

    return false;
  }

  Future<DocumentReference<Map<String, dynamic>>?> getGroupDocumentRef(
      String groupId) async {
    if (await isGroupExist(groupId)) {
      return FirebaseFirestore.instance
          .collection(FireBaseConstants.groupCollection)
          .doc(groupId);
    }

    return null;
  }

  Future<void> createGroup(
      {required String groupName, required String admin}) async {
    final groupRef = await generateEmptyGroupCollection();
    groupRef.update(ChatAppGroup(
        gid: groupRef.id,
        name: groupName,
        discreption: "",
        admin: admin,
        groupIconColor: Colors.teal,
        groupProfileUrl: "",
        members: [admin]).toJson());
    _userDataControler.addGroupInUserData(uid: admin, groupId: groupRef.id);
    Get.snackbar("info", "group $groupName is created sucsses fully");
  }

  Future<DocumentReference<Map<String, dynamic>>>
      generateEmptyGroupCollection() async {
    return await FirebaseFirestore.instance
        .collection(FireBaseConstants.groupCollection)
        .add({});
  }

  Future<void> addUserInGroup(
      {required String gid, required String uid}) async {
    final group = await getGroup(gid);
    if (group != null && !group.value.members.contains(uid)) {
      group.value.members.add(uid);
      final groupRef = (await getGroupDocumentRef(gid))!;
      groupRef.update({GroupJsonKey.members: group.value.members});
      _userDataControler.addGroupInUserData(uid: uid, groupId: gid);
    }
  }

  Future<void> deleteUserFromGroup(
      {required String gid, required String uid}) async {
    final group = await getGroup(gid);
    if (group != null && group.value.members.contains(uid)) {
      group.value.members.remove(uid);
      final groupRef = (await getGroupDocumentRef(gid))!;
      groupRef.update({GroupJsonKey.members: group.value.members});
      _userDataControler.deleteGroupFromUserData(uid: uid, groupId: gid);
    }
  }

  Future<bool> updateGroupData({
    required String gid,
    String? name,
    String? discription,
    String? admin,
    Color? groupIconColor,
    String? groupPhotoUrl,
  }) async {
    final groupRef = await getGroupDocumentRef(gid);
    final group = await getGroup(gid);
    if (groupRef != null && group != null) {
      final updatedGroup = ChatAppGroup(
          gid: gid,
          name: name ?? group.value.name,
          admin: group.value.admin,
          discreption: discription ?? group.value.discreption,
          members: group.value.members,
          groupIconColor: groupIconColor ?? group.value.groupIconColor,
          groupProfileUrl: groupPhotoUrl ?? group.value.groupProfileUrl);
      groupRef.update(updatedGroup.toJson());
      return true;
    }

    return false;
  }

  Future<void> deleteGroup(String gid) async {
    final docRef = await getGroupDocumentRef(gid);
    if (docRef != null) {
      docRef.delete();
    }
  }
}
