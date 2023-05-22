import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/constants/firebase_constants.dart';
import 'package:pchat/constants/key_constants.dart';
import 'package:pchat/helper/stream_lisiner_helper.dart';
import 'package:pchat/models/group_model.dart';
import 'package:pchat/models/user_model.dart';

class FireStoreUserDataControler extends GetxController {
  @override
  Future<void> onClose() async {
    super.onClose();
    // StreamLisinerHelper.closeUserSubscription();
  }

  Future<bool> addUserInDataBase(User user, {String? userName}) async {
    try {
      await FirebaseFirestore.instance
          .collection(FireBaseConstants.userCollection)
          .doc(user.uid)
          .set(ChatAppUser(
            address: "",
            email: user.email ?? "email is not here",
            groupUserAdded: <String>[],
            name: userName ?? user.displayName ?? "",
            info: "",
            profileColor: Colors.teal,
            profileUrl: user.photoURL ?? "",
            uid: user.uid,
          ).toJson());
    } catch (e) {
      Get.snackbar("error in adding user", e.toString());
      // print(e);
    }

    return true;
  }

  Future<Rx<ChatAppUser>?> getUserFromDataBase(String uid) async {
    if (uid.isNotEmpty) {
      try {
        final userDocument = await getUserDucumentRefrance(uid);

        if (userDocument != null) {
          Rx<ChatAppUser> user = Rx(ChatAppUser.fromjson(
            await userDocument.get().then((value) {
              return value.data()!;
            }),
          ));

          final sub = userDocument.snapshots().listen((event) {
            // print("lisining user firestore   $event");
            user.value = ChatAppUser.fromjson(event.data()!);
          }, onDone: (() => user.close()), cancelOnError: true);

          StreamLisinerHelper.addUserSubscription(sub);
          return user;
        }
      } catch (e) {
        Get.snackbar("error in getting user $uid", e.toString());
        // print(e);
      }
    }
    return null;
  }

  Future<Rx<ChatAppUser>?> getOrCreateUserInDataBase(User user) async {
    if (!(await isUserExist(user.uid))) {
      await addUserInDataBase(user);
    }
    return getUserFromDataBase(user.uid);
  }

  Future<RxList<Rx<ChatAppUser>>> getRXUsersOfGroupFromDataBase(
      Rx<ChatAppGroup> group) async {
    RxList<Rx<ChatAppUser>> users = <Rx<ChatAppUser>>[].obs;
    getUsersFromDataBase(group.value.members)
        .then((value) => users.value = value);

    final sub = group.stream.listen((newGroup) async {
      users.value = await getUsersFromDataBase(newGroup.members);
    });
    StreamLisinerHelper.addUserSubscription(sub);

    return users;
  }

  Future<List<Rx<ChatAppUser>>> getUsersFromDataBase(
      List<String> usersId) async {
    List<Rx<ChatAppUser>> users = [];

    for (var uid in usersId) {
      final user = await getUserFromDataBase(uid);

      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  Future<bool> isUserExist(String uid) async {
    if (uid.isNotEmpty) {
      if (await FirebaseFirestore.instance
          .collection(FireBaseConstants.userCollection)
          .doc(uid)
          .get()
          .then((value) => value.exists)) {
        return true;
      }
    }
    return false;
  }

  Future<DocumentReference<Map<String, dynamic>>?> getUserDucumentRefrance(
      String uid) async {
    if (await isUserExist(uid)) {
      return FirebaseFirestore.instance
          .collection(FireBaseConstants.userCollection)
          .doc(uid);
    }
    return null;
  }

  Future<void> addGroupInUserData(
      {required String uid, required String groupId}) async {
    final userRef = await getUserDucumentRefrance(uid);
    final user = await getUserFromDataBase(uid);

    if (userRef != null &&
        user != null &&
        !user.value.groupUserAdded.contains(groupId)) {
      user.value.groupUserAdded.add(groupId);
      userRef.update({UserJsonKey.groupUserAdded: user.value.groupUserAdded});
    }
  }

  Future<void> deleteGroupFromUserData(
      {required String uid, required String groupId}) async {
    final userRef = await getUserDucumentRefrance(uid);
    final user = await getUserFromDataBase(uid);

    if (userRef != null &&
        user != null &&
        user.value.groupUserAdded.contains(groupId)) {
      user.value.groupUserAdded.remove(groupId);
      userRef.update({UserJsonKey.groupUserAdded: user.value.groupUserAdded});
    }
  }

  Future<bool> updateUserData({
    required String uid,
    String? name,
    String? info,
    String? email,
    String? address,
    Color? profileColor,
    String? profileUrl,
  }) async {
    final userRef = await getUserDucumentRefrance(uid);
    final user = await getUserFromDataBase(uid);
    if (userRef != null && user != null) {
      final updatedUser = ChatAppUser(
        uid: uid,
        name: name ?? user.value.name,
        email: email ?? user.value.email,
        address: address ?? user.value.address,
        profileColor: profileColor ?? user.value.profileColor,
        profileUrl: profileUrl ?? user.value.profileUrl,
        groupUserAdded: user.value.groupUserAdded,
        info: info ?? user.value.info,
      );
      userRef.update(updatedUser.toJson());
      return true;
    }

    return false;
  }

  Future<RxList<Rx<ChatAppUser>>> getAllUserFromDataBase() async {
    final users = <Rx<ChatAppUser>>[].obs;

    FirebaseFirestore.instance
        .collection(FireBaseConstants.userCollection)
        .orderBy(UserJsonKey.uid)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        if (doc.exists) {
          users.add((await getUserFromDataBase(doc.data()[UserJsonKey.uid]))!);
        }
      }
    });

    FirebaseFirestore.instance
        .collection(FireBaseConstants.userCollection)
        .orderBy(UserJsonKey.uid)
        .snapshots()
        .listen((event) async {
      if (!(event.isBlank ?? true)) {
        bool isUserAdded = false;

        for (var user in users) {
          if (user.value.uid == event.docs.last.data()[UserJsonKey.uid]) {
            isUserAdded = true;
            return;
          }
        }

        if (users.isEmpty || !isUserAdded) {
          users.add((await getUserFromDataBase(
              event.docs.last.data()[UserJsonKey.uid]))!);
        }
      }
    });
    return users;
  }

  Future<void> deleteUser(String uid) async {
    final userRef = await getUserDucumentRefrance(uid);
    if (userRef != null) {
      userRef.delete();
    }
  }
}
