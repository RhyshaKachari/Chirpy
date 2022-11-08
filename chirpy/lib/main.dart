import 'package:chirpy/frontend/MainScreens/home_page.dart';
import 'package:chirpy/frontend/MainScreens/main_screen.dart';
import 'package:chirpy/frontend/NewUserEntry/new_user_entry.dart';
import 'package:chirpy/frontend/auth_ui/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'Backend/firebase/OnlineDatabaseManagement/cloud_data_management.dart';
import 'frontend/auth_ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Chirpy',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: await differentContextDecisionTake(),
    ),
  );
}

Future<Widget> differentContextDecisionTake() async {
  if (FirebaseAuth.instance.currentUser == null) {
    return LogInScreen();
  } else {
    final CloudStoreDataManagement _cloudStorageDataManagement =
        CloudStoreDataManagement();
    final bool _dataPresentResponse =
        await _cloudStorageDataManagement.userRecordPresentOrNot(
            email: FirebaseAuth.instance.currentUser!.email.toString());

    return _dataPresentResponse ? MainScreen() : TakePrimaryUserData();
  }
}
