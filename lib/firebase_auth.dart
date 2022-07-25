import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_task1/Screens/home_page.dart';
import 'package:flutter_task1/Screens/sign_up.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      await user!.updateDisplayName(name);
      user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.defaultDialog(
          title: "No user found",
          middleText: "User not found.Please sign Up first",
          radius: 40,
          contentPadding: EdgeInsets.all(20),
          titlePadding: EdgeInsets.all(20),
          // textConfirm: "Sign Up",
          // onConfirm: (){
          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
          //   // Get.to(SignUp());
          //   }
        );
        //  Get.snackbar("No user found", "No user found. Please Sign Up first");
      } else if (e.code == 'wrong-password') {
        Get.defaultDialog(
            title: "wrong password",
            content: Text("You have entered wrong password"));
      }
    }
    return user;
  }

  static Future<User?> googleSignup(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      user = result.user;
      return user;
    }
  }

  signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    GoogleSignIn().signOut();
    FacebookAuth.instance.logOut();
    auth.signOut();
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

// Future<void>sendLinktoemail(String mail)async{
//   FirebaseAuth auth=FirebaseAuth.instance;
//   return await auth.sendSignInLinkToEmail(email: mail, actionCodeSettings: actionCodeSettings)
// }

  Future<void> resetPassword({required String email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    bool hasError = false;
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      hasError = true;
      print(exception.code);
      if (exception.code == "user-not-found") {
        Get.snackbar("Not found", "User not found");
      }
    } catch (e) {
      hasError = true;

      Get.snackbar("$e", "Not successful");
    } finally {
      if (!hasError) {
        Get.defaultDialog(
          
            title: "Reset password",
            middleText:
                "Reset password link has been sent to your mail.\n Please check spam folder if not found");
      }
    }
  }

// adduser({required String fullName,
//     required String password,
//     required String email,})async{
//       await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(({
//         'uid':FirebaseAuth.instance.currentUser!.uid,
//         'username':fullName,
//         'email':email
//       }));

//     }

  addUser({
    required String fullName,
  
    required String email,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'Name': fullName, 'email': email,});
      print("success");
    } catch (e) {
      print(e);
    }
  }

  verifyPhoneNumber(String verificationcode, String phoneNumber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91 " + phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth
              .signInWithCredential(phoneAuthCredential)
              .then((value) async {
            if (value != null) {
              // Get.to(HomePage());
              print("logged in");
            }
          });
          Get.snackbar(
              "Number verified", "signed in to ${_auth.currentUser!.uid}");
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("${e.code}", "${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) async {
          verificationcode = verificationId;

          // String smscode = 'xxxx';
          // PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          //     verificationId: verificationId, smsCode: smscode);
          // await _auth.signInWithCredential(phoneAuthCredential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationcode = verificationId;
        },
        timeout: Duration(seconds: 30),
      );
    } catch (e) {
      print(e);
    }
  }
}
 
 
  // Future<User?>refreshUser(User user)async{
  //   FirebaseAuth auth=FirebaseAuth.instance;
  //   await user.reload();
  //   User?refreshedUser=auth.currentUser;
  //   return refreshedUser;
  // }



