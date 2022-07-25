import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task1/Screens/forgetpage.dart';
import 'package:flutter_task1/Screens/home_page.dart';
import 'package:flutter_task1/Screens/sign_up.dart';
import 'package:flutter_task1/Screens/splash_screen.dart';
import 'package:flutter_task1/firebase_auth.dart';
import 'package:flutter_task1/my_textfield.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _passvisibility = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    log(height.toString());
    log(height.toString());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF5F5F5),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 99),
                  child: Image.asset("assets/Images/logo.png"),
                ),
                SizedBox(
                  height: 38,
                ),
                Text(
                  "Log in",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 33,
                ),
                Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Email cannot be empty"),
                            EmailValidator(errorText: "Must be valid email")
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff230A06).withOpacity(0.5),
                                fontSize: 12,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 45,
                                  width: 48,
                                  child: Center(
                                    child: SvgPicture.asset(
                                        "assets/Images/email.svg"),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 250, 242, 240),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: password,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "password cannot be empty"),
                          ]),
                          obscureText: _passvisibility,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Color(0xff230A06).withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              suffixIcon: IconButton(
                                color: Color(0xff230A06).withOpacity(0.5),
                                icon: _passvisibility
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passvisibility = !_passvisibility;
                                  });
                                },
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Center(
                                    child: SvgPicture.asset(
                                        "assets/Images/Lock.svg"),
                                  ),
                                  height: 45,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 250, 242, 240),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Get.to(ForgetPage());
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff230A06),
                              fontWeight: FontWeight.w400),
                        ))),
                SizedBox(
                  height: 17,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        User? user = await FireAuth.signInUsingEmailPassword(
                            email: email.text,
                            password: password.text,
                            context: context);
                        if (user != null) {
                          Get.off(HomePage());
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(205, 59),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(133)),
                        primary: Color(0xffF67952)),
                    child: Text(
                      "Log In",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: 43,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 51),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Color(0xff232E24),
                      )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18.8, 0, 19.8, 0),
                        child: Text(
                          "Or",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        color: Color(0xff232E24),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          FireAuth().signInWithFacebook();
                          Get.to(HomePage());
                        },
                        child: SvgPicture.asset(
                            "assets/socialmedia/facebook.svg")),
                    SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                        onTap: () async {
                          User? user = await FireAuth.googleSignup(context);
                          if (user != null) {
                            Get.to(HomePage());
                          }
                        },
                        child:
                            SvgPicture.asset("assets/socialmedia/google.svg")),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff230A0680),
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () {
                        // Get.to(SignUp());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
// enum _SupportState { unknown, supported, unsupported }
  // final LocalAuthentication auth = LocalAuthentication();
  // bool? _canCheckbiometrics;
  // _SupportState _supportState = _SupportState.unknown;
  // List<BiometricType>? _availableBiometrics;
  // String _authorized = 'Not Authorized';
  // bool _isauthenticating = false;
  // // @override
  // // void initState() {
  // //   // TODO: implement initState
  // //   super.initState();
  // //   auth.isDeviceSupported().then((bool isSupported) => setState(() {
  // //         _supportState =
  // //             isSupported ? _SupportState.supported : _SupportState.unsupported;
  // //       }));
  // //   _checkBiometrics();
  // //   _getAvailableBiometrics();
  // //   _authenticate();
  // // }

  // Future<void> _checkBiometrics() async {
  //   late bool canCheckBiometrics;
  //   try {
  //     canCheckBiometrics = await auth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     canCheckBiometrics = false;
  //     print(e);
  //   }
  //   if (!mounted) {
  //     return;
  //   }
  //   setState(() {
  //     _canCheckbiometrics = canCheckBiometrics;
  //   });
  // }

  // Future<void> _getAvailableBiometrics() async {
  //   late List<BiometricType> availableBiometrics;
  //   try {
  //     availableBiometrics = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     availableBiometrics = <BiometricType>[];
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _availableBiometrics = availableBiometrics;
  //   });
  // }

  // Future<void> _authenticate() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isauthenticating = true;
  //       _authorized = "Authenticating";
  //     });
  //     authenticated = await auth.authenticate(
  //         localizedReason: "Let OS determine authentication method",
  //         options: AuthenticationOptions(
  //             stickyAuth: true, useErrorDialogs: true, biometricOnly: false));
  // if(authenticated)

  //     if (authenticated != true) {
  //       SystemNavigator.pop();
  //     }
  //     setState(() {
  //       _isauthenticating = false;
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //     setState(() {
  //       _isauthenticating = false;
  //       _authorized = 'Erroe-${e.message}';
  //     });
  //     return;
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _authorized = authenticated ? 'Authorized' : 'Not Authorized';
  //   });
  // }

  // Future<void> _cancelAuthentication() async {
  //   await auth.stopAuthentication();
  //   setState(() {
  //     _isauthenticating = false;
  //   });
  // }
}
