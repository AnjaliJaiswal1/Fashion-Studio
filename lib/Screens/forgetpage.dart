import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_task1/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key}) : super(key: key);

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  GlobalKey<FormState> forgetkey = GlobalKey<FormState>();
  TextEditingController mail = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Reset Password",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
                child: TextFormField(
              key: forgetkey,
              controller: mail,
              validator: RequiredValidator(errorText: "Required"),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                      color: Color(0xff230A06).withOpacity(0.5), fontSize: 12),
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
                      height: 45,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 250, 242, 240),
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                    ),
                  )),
            )),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                FireAuth().resetPassword(email: mail.text);
              
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Reset password",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              style: TextButton.styleFrom(backgroundColor: Color(0xffF67952)),
            )
          ]),
        ),
      ),
    );
  }
}
