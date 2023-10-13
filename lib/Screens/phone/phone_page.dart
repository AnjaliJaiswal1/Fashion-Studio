import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task1/Screens/forgetpage.dart';
import 'package:flutter_task1/Screens/home_page.dart';
import 'package:flutter_task1/Screens/phone/otp_page.dart';
import 'package:flutter_task1/Screens/sign_up.dart';
import 'package:flutter_task1/firebase_auth.dart';
import 'package:flutter_task1/my_textfield.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../main.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController phonenumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  height: height10 * 3.8,
                ),
                Text(
                  "Log in",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: height10 * 3.3,
                ),
                Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: phonenumber,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Required"),
                          ]),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: "+91-9030xxxxxxxxx",
                              hintStyle: TextStyle(
                                  color: Color(0xff230A06).withOpacity(0.5),
                                  fontSize: 12),
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
                                  child: Center(
                                    child: SvgPicture.asset(
                                        "assets/Images/phone.svg"),
                                  ),
                                  height: height10 * 4.5,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 250, 242, 240),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: height10 * 1.6,
                        ),
                      ],
                    )),
                SizedBox(
                  height: height10 * 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        Get.to(OtpVerification(
                          phoneNumber: phonenumber.text,
                        ));
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
}
