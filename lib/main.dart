import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pchat/firebase_options.dart';
import 'package:pchat/views/loding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    print("main build");
    return GetMaterialApp(
      title: 'PChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const LoddingScreen(),
    );
  }
}
