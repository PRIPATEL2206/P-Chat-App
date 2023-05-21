import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pchat/controlers/firebase_firestore_userdata_controler.dart';
import 'package:pchat/helper/stream_lisiner_helper.dart';
import 'package:pchat/models/user_model.dart';

class AuthControler extends GetxController {
  final RxBool _isUserLogin = false.obs;
  Rx<ChatAppUser>? _chatAppCurrentUser;
  final RxBool _isLodding = false.obs;
  final FireStoreUserDataControler _fireStoreUserDataControler;

  AuthControler(this._fireStoreUserDataControler);
  // init Auth
  Future<void> initAuth() async {
    // FirebaseAuth.instance.signOut();
    _isLodding.value = true;
    final cuser = FirebaseAuth.instance.currentUser;
    if (cuser == null) {
      _chatAppCurrentUser = null;
      _isUserLogin.value = false;
    } else {
      _chatAppCurrentUser =
          await _fireStoreUserDataControler.getOrCreateUserInDataBase(cuser);
      _isUserLogin.value = _chatAppCurrentUser == null ? false : true;
    }

    FirebaseAuth.instance.authStateChanges().listen(
      (user) async {
        print("lisining auth");
        user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          _chatAppCurrentUser = null;
          _isUserLogin.value = false;
          _isLodding.value = false;
          return;
        }
        try {
          _chatAppCurrentUser =
              await _fireStoreUserDataControler.getOrCreateUserInDataBase(user);
          print(_chatAppCurrentUser?.value.toJson());
          _isUserLogin.value = _chatAppCurrentUser == null ? false : true;
        } catch (e) {
          Get.snackbar("error in user change", e.toString());
        }
      },
      onError: (e) => Get.snackbar("error in lisining", e.toString()),
      onDone: () => _chatAppCurrentUser?.close(),
    );
    _isLodding.value = false;
  }

  // geters here
  Rx<ChatAppUser>? get currentUser => _chatAppCurrentUser;
  RxBool get isUserLogin => _isUserLogin;
  RxBool get isLodding => _isLodding;

  // seters here

  // fuctions

// login user
  Future<bool> loginUserWithEmailAndPassword(
      {required String email, required String password}) async {
    _isLodding.value = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("login sucsses");
      _isLodding.value = false;
      return true;
    } catch (e) {
      Get.snackbar("error in login ", e.toString());
      print(e);
    }

    _isLodding.value = false;
    return false;
  }

// register user
  Future<bool> registerUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String userName}) async {
    _isLodding.value = true;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _isLodding.value = false;
      return true;
      // if (newUser != null) {
      //   _isLodding.value = false;
      //   return await _fireStoreUserDataControler.addUserInDataBase(newUser,
      //       userName: userName);
      // }
    } catch (e) {
      Get.snackbar("error in registration", e.toString());
      print(e);
    }

    _isLodding.value = false;
    return false;
  }

// logout user
  Future<bool> logOut() async {
    _isLodding.value = true;
    if (_isUserLogin.value) {
      _isUserLogin.value = false;
      await StreamLisinerHelper.closeAllSubscription();
      FirebaseAuth.instance.signOut();
      print("logout Sucsessfully");
      _isLodding.value = false;
      return true;
    }
    _isLodding.value = false;
    return false;
  }

// delete user account
  Future<bool> deleteAcount() async {
    _isLodding.value = true;
    _isLodding.value = false;

    return true;
  }
}
