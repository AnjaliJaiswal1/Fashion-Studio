import 'package:flutter/material.dart';
import 'package:flutter_task1/Screens/login_screen.dart';
import 'package:flutter_task1/firebase_auth.dart';
import 'package:get/get.dart';

import '../main.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to home page"),
              TextButton(
                  onPressed: () {
                    // FirebaseAuth.instance.signOut();
                    FireAuth().signOut();
                    Get.to(LoginPage());
                  },
                  child: Text("log out")),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: height10 * 8.3,
        width: 375,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.home)),
           IconButton(onPressed: (){}, icon: Icon(Icons.search)),
           IconButton(onPressed: (){}, icon: Icon(Icons.bookmark)),
           IconButton(onPressed: (){}, icon: Icon(Icons.home)),
        ],),
      ),
    );
  }
}
