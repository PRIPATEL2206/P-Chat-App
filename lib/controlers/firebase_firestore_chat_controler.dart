import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pchat/constants/firebase_constants.dart';
import 'package:pchat/constants/key_constants.dart';
import 'package:pchat/controlers/firebase_firestore_groupdata.dart';
import 'package:pchat/helper/stream_lisiner_helper.dart';
import 'package:pchat/models/chat_model.dart';

class FireStoreChatControler extends GetxController {
  final FireStoreGroupDataControler _groupDataControler;
  FireStoreChatControler(this._groupDataControler);

  @override
  Future<void> onClose() async {
    super.onClose();
    StreamLisinerHelper.closeChatSubscription();
  }

  Future<RxList<Chat>> getChatsOfGroup(String groupId) async {
    final RxList<Chat> chats = RxList();

    try {
      final groupRef = await _groupDataControler.getGroupDocumentRef(groupId);
      if (groupRef != null) {
        if (!(groupRef.collection(FireBaseConstants.chatsCollection).isBlank ??
            false)) {
          chats.value = await groupRef
              .collection(FireBaseConstants.chatsCollection)
              .orderBy(ChatJsonKey.dateTime, descending: false)
              .get()
              .then((value) {
            final List<Chat> innerChats = [];
            for (var chat in value.docs) {
              if (chat.exists) {
                innerChats.add(Chat.fromJson(chat.data()));
              }
            }
            return innerChats;
          });
        }

        final sub = groupRef
            .collection(FireBaseConstants.chatsCollection)
            .orderBy(ChatJsonKey.dateTime, descending: false)
            .snapshots()
            .listen((event) {
          if (chats.last.cid != event.docs.last.data()[ChatJsonKey.cid]) {
            chats.add(Chat.fromJson(event.docs.last.data()));
          }
          // for (final chat in event.docs) {
          //   if (chat.exists) {
          //     ;
          //   }
          // }
        });
        StreamLisinerHelper.addChatSubscription(sub);
      }
    } catch (e) {
      Get.snackbar("chat get error", e.toString());
    }
    return chats;
  }

  Future<void> sendMessage({
    required String groupId,
    required String message,
    required String sendBy,
  }) async {
    final chatRef = await createEmptyChat(groupId);
    if (chatRef != null) {
      chatRef.update(Chat(
              cid: chatRef.id,
              message: message,
              sendBy: sendBy,
              dateTime: DateTime.now(),
              isRecived: false)
          .toJson());
    }
  }

  Future<DocumentReference<Map<String, dynamic>>?> createEmptyChat(
      String groupId) async {
    try {
      final groupRef = await _groupDataControler.getGroupDocumentRef(groupId);
      if (groupRef != null) {
        return await groupRef
            .collection(FireBaseConstants.chatsCollection)
            .add({});
      }
    } catch (e) {
      Get.snackbar("error in generating empty chat", e.toString());
    }
    return null;
  }
}
