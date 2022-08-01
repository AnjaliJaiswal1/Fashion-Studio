// import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task1/Screens/app_lock.dart';
import 'package:flutter_task1/Screens/login_screen.dart';
import 'package:flutter_task1/Screens/map/location.dart';
import 'package:flutter_task1/Screens/map/rough.dart';
import 'package:flutter_task1/Screens/map/rough_search.dart';
import 'package:flutter_task1/Screens/map/search.dart';
import 'package:flutter_task1/Screens/map/search_places.dart';
import 'package:flutter_task1/Screens/phone/phone_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_task1/Screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(MyApp());
}

final double get_height = Get.height;
final double height10 = get_height / 82.5;


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme()),
      title: "Task 1",
      // home: Search(),
      home: NewAddressPage(),
    );
  }
}
