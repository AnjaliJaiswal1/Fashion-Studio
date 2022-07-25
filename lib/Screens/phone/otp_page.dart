import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_task1/Screens/home_page.dart';
import 'package:flutter_task1/firebase_auth.dart';
import 'package:flutter_task1/my_textfield.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OtpVerification extends StatefulWidget {
  String phoneNumber;
  OtpVerification({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String timetodisplay = "00:30";
  bool resend = false;
  bool time = true;
  int m = 00, s = 30;
  int timefortimer = 30;

  String pincode = '';
  OtpFieldController pin = OtpFieldController();
  String? verificationcode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhoneNumber();
    start();
  }

  void start() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timefortimer < 1) {
          timer.cancel();
          timetodisplay = "00:00";
          resend = true;
        } else {
          s = timefortimer - 1;
          timetodisplay = m.toString() + ":" + s.toString();
          timefortimer = timefortimer - 1;
        }
      });
    });
  }

  void reset() {
    timetodisplay = "00:30";

    resend = false;
    time = true;
    m = 00;
    s = 30;
    timefortimer = 30;
    start();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height10*5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Verification",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Text(
                    // "otp has been sent to ${widget.phoneNumber}",
                    "OTP has been sent to ${widget.phoneNumber.replaceRange(3, 7, "****")}",
                    style: TextStyle(
                        color: Color(0xff9E9E9E),
                        fontSize: 14,
                        letterSpacing: 0.005),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter OTP",
                    style: TextStyle(
                        color: Color(0xff9E9E9E),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: height10,
                  ),
                  Center(
                    child: OTPTextField(
                        width: MediaQuery.of(context).size.width,
                        keyboardType: TextInputType.number,
                        outlineBorderRadius: 0,
                        fieldWidth: 48,
                        textFieldAlignment: MainAxisAlignment.start,
                        length: 6,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        contentPadding: EdgeInsets.all(10),
                        fieldStyle: FieldStyle.box,
                        controller: pin,
                        onChanged: (pin) {},
                        onCompleted: (pin) async {
                          setState(() {
                            pincode = pin;
                          });
                        }),
                  ),
                  SizedBox(
                    height: height10*2,
                    // height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        timetodisplay,
                        style: TextStyle(
                            color: Color(0xffFB344F),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      TextButton(
                          onPressed: resend
                              ? () {
                                  verifyPhoneNumber();
                                  reset();
                                }
                              : null,
                          child: Text(
                            "Re-Send Code",
                            style: TextStyle(
                                color: resend
                                    ? Color(0xff00880D)
                                    : Color.fromARGB(255, 180, 204, 182),
                                letterSpacing: 0.005),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: height10*35,
                    // height: 350,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          print("code --- " + pincode.toString());
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId:
                                            verificationcode.toString(),
                                        smsCode: pincode.toString()))
                                .then((value) async {
                              if (value != null) {
                                Get.to(HomePage());
                              }
                            });
                          } catch (e) {
                            print(e);
                            Get.snackbar(
                                "Invalid OTP", "you have entered wrong opt",
                                animationDuration: Duration(seconds: 5));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(205, 59),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(133)),
                            primary: Color(0xffF67952)),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  verifyPhoneNumber() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91 " + widget.phoneNumber.toString(),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth
              .signInWithCredential(phoneAuthCredential)
              .then((value) async {
            if (value != null) {
              print("logged in");
            }
          });
          Get.snackbar(
              "Number verified", "signed in to ${_auth.currentUser!.uid}",
              animationDuration: Duration(seconds: 5));
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("${e.code}", "${e.message}",
              backgroundColor: Colors.white,
              animationDuration: Duration(seconds: 5));
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            verificationcode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verificationcode = verificationId;
          });
        },
        timeout: Duration(seconds: 30),
      );
    } catch (e) {
      print(e);
    }
  }
}
