import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_task1/Screens/login_screen.dart';
import 'package:flutter_task1/my_textfield.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds:400), () => Get.off(LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Images/logo.png"),
            SizedBox(
              height:height10,
              // height: 30,
            ),
            Text("Fashion Studio",
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 22,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
