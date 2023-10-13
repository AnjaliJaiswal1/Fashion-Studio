import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task1/Screens/home_page.dart';
import 'package:flutter_task1/Screens/map/search.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import '../../main.dart';

const kGoogleApiKey = 'AIzaSyD2dcjAKRXXxaLn2WeatT69_RsW_loOOEg';

class Mapsample extends StatefulWidget {
  @override
  State<Mapsample> createState() => MapsampleState();
}

class MapsampleState extends State<Mapsample> {
  //  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller;
  CameraPosition? cameraPosition;

  LatLng? _initialPosition;
  // Set<Marker> markers = Set();
  late BitmapDescriptor markerIcon;
  String? place;
  StreamController<LatLng> streamController = StreamController();
  String? p;
  LatLng? initpos;
  Set<Marker> markerlist = Set();
  bool issearched = false;
  bool work = false;
  bool other = false;
  bool home = false;
  bool enableconfirm = false;

  @override
  void initState() {
    _getUserLocation();
    destinationMarkerIcon();
    super.initState();
  }

  destinationMarkerIcon() async {
    final Uint8List destinationMarkerIcon =
        await getBytesFromAsset('assets/map/marker.png', 400);
    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(destinationMarkerIcon);
      markerlist.add(Marker(
        markerId: MarkerId(_initialPosition.toString()),
        infoWindow: InfoWindow(
            title:
                "Order will be delivery here \n Place the pin accurately on the map"),
        position:
            _initialPosition ?? LatLng(17.41287503151813, 78.43761731026065),
        icon: markerIcon,
      ));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void getloc(double lat, double lng) async {
    List<Placemark> place = await placemarkFromCoordinates(lat, lng);
    p = place[4].name.toString() +
        "," +
        place[4].subLocality.toString() +
        "," +
        place[4].locality.toString();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // initpos = LatLng(position.latitude, position.longitude);
    streamController.add(_initialPosition as LatLng);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
      // place = placemark[4].name;
      place = placemark[3].locality.toString() +
          ", " +
          placemark[3].name.toString();
    });
  }

  static final CameraPosition wielab = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(17.41287503151813, 78.43761731026065),
      // tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _controller.animateCamera(CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(_initialPosition!.latitude , _initialPosition!.longitude), zoom: 15)));
      //   },
      //   child: Icon(Icons.location_searching_outlined),
      // ),
      backgroundColor: Colors.white,
      body: _initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onCameraMove: (CameraPosition pos) {
                    streamController.add(pos.target);
                  },
                  //markers: markerlist,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _initialPosition ??
                          LatLng(17.41287503151813, 78.43761731026065),
                      zoom: 14),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    // _controller.complete(controller);
                  },
                ),
                Positioned(
                    top: 200,
                    left: Get.width / 3,
                    child: Image.asset(
                      'assets/map/marker.png',
                      height: 100,
                      fit: BoxFit.cover,
                    )),
              ],
            ),
      bottomNavigationBar: issearched
          ? Container(
              margin: EdgeInsets.fromLTRB(15, 26, 8, 20),
              height: context.heightTransformer(dividedBy: 2.5),
              width: Get.width,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SELECT DELIVERY LOCATION",
                        style: TextStyle(
                            color: Color(0xff1C1A19).withOpacity(0.5),
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: height10 * 3.4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset("assets/map/location.svg"),
                              // Icon(Icons.location_on_outlined),
                              Text("Current Location",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                          Spacer(),
                          ElevatedButton(
                              onPressed: () {
                                // Get.to(SearchPlace());
                                _handlePressButton();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(80, 33),
                                primary: Color(0xffF67952).withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(133),
                                ),
                              ),
                              child: Text(
                                "CHANGE",
                                style: TextStyle(
                                    color: Color(0xff1C1A1980),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: height10,
                      ),
                      StreamBuilder<LatLng>(
                        stream: streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            getloc(snapshot.data!.latitude,
                                snapshot.data!.longitude);

                            return Text(
                              "$p",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff1C1A19).withOpacity(0.5)),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),

                      // Text(
                      //   "$place",
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xff1C1A19).withOpacity(0.5)),
                      // ),
                      SizedBox(
                        height: height10 * 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  work = false;
                                  other = false;
                                  home = true;
                                  enableconfirm = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(80, 33),
                                primary: home
                                    ? Color(0xFFF67952)
                                    : Color(0xffF67952).withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(133),
                                ),
                              ),
                              child: Text(
                                "Home",
                                style: TextStyle(
                                    color: home
                                        ? Colors.white
                                        : Color(0xff1C1A1980),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  work = true;
                                  other = false;
                                  home = false;
                                  enableconfirm = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(80, 33),
                                primary: work
                                    ? Color(0xFFF67952)
                                    : Color(0xffF67952).withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(133),
                                ),
                              ),
                              child: Text(
                                "WORK",
                                style: TextStyle(
                                    color: work
                                        ? Colors.white
                                        : Color(0xff1C1A1980),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  work = false;
                                  other = true;
                                  home = false;
                                  enableconfirm = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(80, 33),
                                primary: other
                                    ? Color(0xFFF67952)
                                    : Color(0xffF67952).withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(133),
                                ),
                              ),
                              child: Text(
                                "other",
                                style: TextStyle(
                                    color: other
                                        ? Colors.white
                                        : Color(0xff1C1A1980),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: height10 * 1.5,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              enableconfirm
                                  ? setState(() {
                                      if (other == true ||
                                          work == true ||
                                          home == true) {
                                        Get.to(HomePage());
                                      }
                                    })
                                  : null;
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(205, 59),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(133)),
                                primary: enableconfirm
                                    ? Color(0xFFF67952)
                                    : Color(0xffF67952).withOpacity(0.1)),
                            child: Text(
                              "confirm",
                              style: TextStyle(
                                  color: enableconfirm
                                      ? Colors.white
                                      : Color(0xff1C1A1980),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ]),
              ),
            )
          : Container(
              margin: EdgeInsets.fromLTRB(15, 26, 8, 20),
              // height: 250,
              height: context.heightTransformer(dividedBy: 3.1),
              width: Get.width,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SELECT DELIVERY LOCATION",
                        style: TextStyle(
                            color: Color(0xff1C1A19).withOpacity(0.5),
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: height10 * 3.4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Icon(Icons.location_on_outlined),
                              SvgPicture.asset("assets/map/location.svg"),
                              Text("Current Location",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                          Spacer(),
                          ElevatedButton(
                              onPressed: () {
                                // Get.to(SearchPlace());
                                _handlePressButton();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(80, 33),
                                primary: Color(0xffF67952).withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(133),
                                ),
                              ),
                              child: Text(
                                "CHANGE",
                                style: TextStyle(
                                    color: Color(0xff1C1A1980),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: height10,
                      ),
                      StreamBuilder<LatLng>(
                        stream: streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            getloc(snapshot.data!.latitude,
                                snapshot.data!.longitude);

                            return Text(
                              "$p",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff1C1A19).withOpacity(0.5)),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),

                      // Text(
                      //   "$place",
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xff1C1A19).withOpacity(0.5)),
                      // ),
                      SizedBox(
                        height: height10 * 3,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Get.to(HomePage());
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(205, 59),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(133)),
                                primary: Color(0xFFF67952)),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                      ),
                    ]),
              ),
            ),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: (value) {
          Get.snackbar(
              value.errorMessage.toString(), value.errorMessage.toString());
        },
        mode: Mode.fullscreen,
        language: 'en',
        types: [""]);
    displayPrediction(
        p!); //!null check error if goes bacl--------------------------------------------
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    markerlist.clear();
    markerlist.add(Marker(
        icon: markerIcon,
        markerId: MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));
    setState(() {
      place = detail.result.formattedAddress;
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15)));
      issearched = true;
      work = false;
      other = false;
      home = false;
      enableconfirm = false;
    });
  }
}













// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:flutter_task1/Screens/map/search.dart';
// import 'package:get/get.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_webservice/places.dart';
// import '../../main.dart';

// const kGoogleApiKey = 'AIzaSyD2dcjAKRXXxaLn2WeatT69_RsW_loOOEg';
// class MapSample extends StatefulWidget {
//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   // Completer<GoogleMapController> _controller = Completer();
//   late GoogleMapController _controller;
//   CameraPosition? cameraPosition;

//   LatLng? _initialPosition;
//   // Set<Marker> markers = Set();
//   late BitmapDescriptor markerIcon;
//   String? place;
//   StreamController<LatLng> streamcontroller= StreamController();

  
//   Set<Marker> markerlist = Set();

//   // late Position currentposition= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//   @override
//   void initState() {
//     _getUserLocation();
//     destinationMarkerIcon();
//     super.initState();
//   }
//    @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//     streamcontroller.close();
//   }

//   destinationMarkerIcon() async {
//     final Uint8List destinationMarkerIcon =
//         await getBytesFromAsset('assets/map/marker.png', 400);
//     setState(() {
//       markerIcon = BitmapDescriptor.fromBytes(destinationMarkerIcon);
//       markerlist.add(Marker(
//         markerId: MarkerId(_initialPosition.toString()),
//         infoWindow: InfoWindow(
//             title:
//                 "Order will be delivery here \n Place the pin accurately on the map"),
//         position:
//             LatLng(_initialPosition!.latitude, _initialPosition!.longitude),
//         icon: markerIcon,
//       ));
//     });
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   void _getUserLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     List<Placemark> placemark =
//         await placemarkFromCoordinates(position.latitude, position.longitude);

//     setState(() {
//       _initialPosition = LatLng(position.latitude, position.longitude);
//       print('${placemark[0].name}');
//       // place = placemark[4].name;
//       place = placemark[3].locality.toString() +
//           ", " +
//           placemark[3].name.toString();
//     });
//   }

//   static final CameraPosition wielab = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(17.41287503151813, 78.43761731026065),
//       // tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _initialPosition == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 GoogleMap(
//                   onCameraMove: (CameraPosition cam){
//                     streamcontroller.add(cam.target);
//                   },
//                   markers: markerlist,
//                   mapType: MapType.normal,
//                   initialCameraPosition:
//                       CameraPosition(target: _initialPosition??LatLng(17.41287503151813, 78.43761731026065), zoom: 14),
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller = controller;
//                     // _controller.complete(controller);
//                   },
//                 ),
//               ],
//             ),
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.fromLTRB(15, 26, 8, 20),
//         height: 250,
//         width: Get.width,
//         color: Colors.white,
//         child: SingleChildScrollView(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "SELECT DELIVERY LOCATION",
//                   style: TextStyle(
//                       color: Color(0xff1C1A19).withOpacity(0.5), fontSize: 16),
//                 ),
//                 SizedBox(
//                   height: height10 * 3.4,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.location_on_outlined),
//                         Text("Current Location",
//                             style: TextStyle(
//                                 fontSize: 22, fontWeight: FontWeight.w400))
//                       ],
//                     ),
//                     Spacer(),
//                     ElevatedButton(
//                         onPressed: () {
//                          // Get.to(SearchPlace());
//                            _handlePressButton();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(80, 33),
//                           primary: Color(0xffF67952).withOpacity(0.1),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(133),
//                           ),
//                         ),
//                         child: Text(
//                           "CHANGE",
//                           style: TextStyle(
//                               color: Color(0xff1C1A1980),
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500),
//                         )),
//                   ],
//                 ),
//                 SizedBox(
//                   height: height10,
//                 ),
//                 Text(
//                   "$place",
//                   style: TextStyle(
//                       fontSize: 16, color: Color(0xff1C1A19).withOpacity(0.5)),
//                 ),
//                 SizedBox(
//                   height: height10 * 3,
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           //  addMarkers();
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                           minimumSize: Size(205, 59),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(133)),
//                           primary: Color(0xFFF67952)),
//                       child: Text(
//                         "Confirm",
//                         style:
//                             TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                       )),
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }
//    Future<void> _handlePressButton() async {
//     Prediction? p = await PlacesAutocomplete.show(
//         context: context,
//         apiKey: kGoogleApiKey,
//         onError: (value) {
//           Get.snackbar(
//               value.errorMessage.toString(), value.errorMessage.toString());
//         },
//         mode: Mode.overlay,
//         language: 'en',
//         types: [""]);
//     displayPrediction(p!);
//   }
//   Future<void>displayPrediction(Prediction p)async{
//     GoogleMapsPlaces places=GoogleMapsPlaces(apiKey: kGoogleApiKey,
//     apiHeaders: await const GoogleApiHeaders().getHeaders());
//     PlacesDetailsResponse detail= await places.getDetailsByPlaceId(p.placeId!);
//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;
//     markerlist.clear();
//     markerlist.add(Marker(
//       icon: markerIcon,
//         markerId: MarkerId("0"),
//         position: LatLng(lat, lng),
//         infoWindow: InfoWindow(title: detail.result.name)));
//     setState(() {
//       place=detail.result.formattedAddress;
//       _controller.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(lat, lng),zoom: 15)));
//     });
//   }
// }
