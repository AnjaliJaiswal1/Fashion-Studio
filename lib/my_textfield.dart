// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// final double heightg= Get.height;
// final double height10 = heightg / 82.5;

// // import 'package:flutter/src/foundation/key.dart';
// // import 'package:flutter/src/widgets/framework.dart';

// class MyTextField extends StatelessWidget {
//   final String? hintText;
//   final AssetImage? formimage;
//   MyTextField({this.formimage, this.hintText});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 57,
//       // width: 335,
//       child: TextFormField(
//         decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: TextStyle(color: Color(0xff230A06), fontSize: 12),
//             filled: true,
//             fillColor: Colors.white,
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.white)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.white)),
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.white)),
//             prefixIcon: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 45,
//                 width: 48,
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 250, 242, 240),
//                   borderRadius: BorderRadius.circular(10),
//                   image: DecorationImage(image: formimage!),
//                 ),
//               ),
//             )),
//       ),
//     );
//   }
// }

// class MyButton extends StatelessWidget {
//   final String? text;
//   final void Function()? onPressed;

//   MyButton({this.text, this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//             minimumSize: Size(205, 59),
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(133)),
//             primary: Color(0xffF67952)),
//         child: Text(
//           "$text",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ));
//   }
// }
// -------------------------------------------------------------------------------------------

 // onTap: () {
                      //   _customInfoWindowController.addInfoWindow!(
                      //     Column(
                      //       children: [
                      //         Expanded(
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               color: Colors.blue,
                      //               borderRadius: BorderRadius.circular(4),
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Icon(
                      //                     Icons.account_circle,
                      //                     color: Colors.white,
                      //                     size: 30,
                      //                   ),
                      //                   SizedBox(
                      //                     width: 8.0,
                      //                   ),
                      //                   Text(
                      //                     "I am here",
                      //                     style: Theme.of(context)
                      //                         .textTheme
                      //                         .headline6
                      //                         ?.copyWith(
                      //                           color: Colors.white,
                      //                         ),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //             width: double.infinity,
                      //             height: double.infinity,
                      //           ),
                      //         ),
                      //         // Triangle.isosceles(
                      //         //   edge: Edge.BOTTOM,
                      //         //   child: Container(
                      //         //     color: Colors.blue,
                      //         //     width: 20.0,
                      //         //     height: 10.0,
                      //         //   ),
                      //         // ),
                      //       ],
                      //     ),
                      //     LatLng(_initialPosition!.latitude,
                      //         _initialPosition!.longitude),
                      //   );
                      // },
        // CustomInfoWindowController _customInfoWindowController =
  // CustomInfoWindowController();

  // -------------------------------------------------------------------------------------------------