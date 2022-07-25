// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseService{
//   Future<String>addUser({
//     required String fullName,
//     required String password,
//     required String email,
//   })async{
//     try{
//       CollectionReference users= FirebaseFirestore.instance.collection('users');
//       await users.doc(email).set({
//         'Name':fullName,
//         'Password':password
//       });
//       return "success";

//     }
//     catch(e){
//       return "error adding user";
//     }
//   }
// }