import 'package:get/get.dart';
import 'package:pchat/controlers/auth_controler.dart';
import 'package:pchat/controlers/firebase_firestore_chat_controler.dart';
import 'package:pchat/controlers/firebase_firestore_groupdata.dart';
import 'package:pchat/controlers/firebase_firestore_userdata_controler.dart';

Future<void> initApp() async {
  // firebase initializetions

  // Api

  // repos

  // controlers
  Get.lazyPut(() => FireStoreUserDataControler());
  Get.lazyPut(() => AuthControler(Get.find<FireStoreUserDataControler>()));
  Get.lazyPut(() =>
      FireStoreGroupDataControler(Get.find<FireStoreUserDataControler>()));
  Get.lazyPut(
      () => FireStoreChatControler(Get.find<FireStoreGroupDataControler>()));

  // initialize User
  Get.find<AuthControler>().initAuth();
}
