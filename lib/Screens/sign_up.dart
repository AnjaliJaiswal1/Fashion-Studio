import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task1/Screens/login_screen.dart';
import 'package:flutter_task1/Screens/phone/phone_page.dart';
import 'package:flutter_task1/firebase_auth.dart';
import 'package:flutter_task1/main.dart';
import 'package:flutter_task1/my_textfield.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> signformkey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _passvisibility = true;
  bool _termcheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.only(top: 90),
                child: Image.asset("assets/Images/logo.png"),
              ),
              SizedBox(height: height10 * 4),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: height10 * 2,
              ),
              Form(
                  key: signformkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namecontroller,
                        keyboardType: TextInputType.text,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Name cannot be empty"),
                        ]),
                        decoration: InputDecoration(
                            hintText: "Name",
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
                                      "assets/Images/profile.svg"),
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
                      SizedBox(
                        height: height10,
                      ),
                      TextFormField(
                        controller: emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Required"),
                          EmailValidator(errorText: "must be valid email"),
                        ]),
                        decoration: InputDecoration(
                            hintText: "Email",
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
                                        "assets/Images/email.svg")),
                                        height: height10*4.5,
                                // height: 45,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 250, 242, 240),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: height10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: passcontroller,
                        obscureText: _passvisibility,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "password cannot be empty"),
                          MinLengthValidator(8,
                              errorText:
                                  "password must be at least 8 character"),
                          PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                              errorText:
                                  'passwords must have at least one special character')
                        ]),
                        decoration: InputDecoration(
                          hintText: "password",
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
                                child:
                                    SvgPicture.asset("assets/Images/Lock.svg"),
                              ),
                              height: height10*4.5,
                              //height: 45,
                              width: 48,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 250, 242, 240),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
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
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                // height: 18,
                height:height10*1.8,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _termcheck = !_termcheck;
                        });
                      },
                      icon: Icon(
                        _termcheck
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Color(0xffF67952),
                      )),
                  Text(
                    "I accept all the ",
                    style: TextStyle(
                        color: Color(0xff230A06).withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Terms & Conditions",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      )),
                ],
              ),
              SizedBox(
                // height: 21,
                height: height10*2,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (signformkey.currentState!.validate() &&
                        _termcheck == true) {
                      User? user = await FireAuth.registerUsingEmailPassword(
                          name: namecontroller.text,
                          email: emailcontroller.text,
                          password: passcontroller.text);
                      FireAuth().addUser(
                          fullName: namecontroller.text,
                          email: emailcontroller.text);
                      Get.to(HomePage());
                    } else if (_termcheck == false) {
                      Get.bottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          backgroundColor: Colors.red[100],
                          Container(
                            height: height10*10,
                            // height: 100,
                            child: Center(
                              child: Text("Terms and condition not agreed"),
                            ),
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
                    "Sign Up",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height:height10*3
                // height: 31,
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
                      child: Text("Or"),
                    ),
                    Expanded(
                        child: Divider(
                      color: Color(0xff232E24),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height:height10*2.5,
                // height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        FireAuth().signInWithFacebook();
                        Get.to(HomePage());
                      },
                      child:
                          SvgPicture.asset("assets/socialmedia/facebook.svg")),
                  GestureDetector(
                      onTap: () async {
                        User? user = await FireAuth.googleSignup(context);
                        if (user != null) {
                          Get.to(HomePage());
                        }
                      },
                      child: SvgPicture.asset("assets/socialmedia/google.svg")),
                  InkWell(
                    onTap: () => Get.to(PhonePage()),
                    child: Container(
                      height: height10*7,
                      // height: 71,
                      width: 71,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: SvgPicture.asset("assets/Images/phone.svg")),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height10/1.4,
                // height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff230A0680),
                        fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    style: TextButton.styleFrom(),
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
