import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewAddressPage extends StatefulWidget {
  @override
  State<NewAddressPage> createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> {
  late GoogleMapController _controller;
  LatLng? markerPos;
  LatLng? initPos;
  Set<Marker> markers = {};
  TextEditingController? searchPlaceController;
  bool loadingMap = false;
  bool init = true;
  bool loadingAddressDetails = false;
  String addressTitle = '';
  String locality = '';
  String city = '';
  String state = '';
  String pincode = '';

  StreamController<LatLng> streamController = StreamController();

  void fetchAddressDetail(LatLng location) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    addressTitle = placemarks[0].name!;
    locality = placemarks[0].locality!;
    city = placemarks[0].subLocality!;
    pincode = placemarks[0].postalCode!;
    state = placemarks[0].administrativeArea!;
  }

  getCurrentLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    initPos = LatLng(position.latitude, position.longitude);
    streamController.add(initPos as LatLng);
    setState(() {
      loadingMap = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingMap = true;
    getCurrentLoc();
    searchPlaceController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    streamController.close();

  }

  renderMap() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: (loadingMap)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              buildingsEnabled: true,
              indoorViewEnabled: false,
              onMapCreated: (controller) {
                _controller = controller;
                setState(() {
                  fetchAddressDetail(initPos!);
                });
              },
              onCameraMove: (CameraPosition pos) {
                streamController.add(pos.target);
              },
              initialCameraPosition: CameraPosition(
                target: initPos!,
                zoom: 14.4746,
              ),
              mapType: MapType.normal,
            ),
    );
  }

  backButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.black87,
      icon: const Icon(Icons.arrow_back),
    );
  }

  searchBox() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black87, width: 0.1),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: TextFormField(
          controller: searchPlaceController,
          onChanged: (value) async {
            // ignore
          },
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: InputBorder.none,
              hintText: "Search Places...",
              labelStyle: TextStyle(color: Colors.black87)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: searchBox(),
          ),
          body: SizedBox(
            child: Stack(
              alignment: Alignment.center,
              children: [
                renderMap(),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset(
                      'assets/map/marker.png',
                      height: 30,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.red[200],
                                size: MediaQuery.of(context).size.width * 0.08,
                              ),
                              const Padding(padding: EdgeInsets.all(2)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addressTitle,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.black87),
                                  ),
                                  const Padding(padding: EdgeInsets.all(2)),
                                  Text(
                                    city,
                                    style: const TextStyle(
                                      fontSize: 6,
                                      color: Colors.black54,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0))),
                                    backgroundColor: Colors.white,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => const Text('ignore'));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(5)),
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Center(
                                    child: StreamBuilder<LatLng>(
                                  stream: streamController.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Text('${snapshot.data!.latitude}'),
                                          Text('${snapshot.data!.longitude}'),
                                        ],
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )

                                    // Text(
                                    //   'Confirm Address',
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 15,
                                    //   ),
                                    // ),
                                    ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}





































// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:flutter_task1/Screens/home_page.dart';
// import 'package:flutter_task1/Screens/map/search.dart';
// import 'package:get/get.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:http/http.dart';
// import '../../main.dart';

// const kGoogleApiKey = '';

// class Mapsample2 extends StatefulWidget {
//   @override
//   State<Mapsample2> createState() => Mapsample2State();
// }

// class Mapsample2State extends State<Mapsample2> {
//   //  Completer<GoogleMapController> _controller = Completer();
//   late GoogleMapController _controller;
//   CameraPosition? cameraPosition;

//   LatLng? _initialPosition;
//   // Set<Marker> markers = Set();
//   late BitmapDescriptor markerIcon;
//   String? place;

//   Set<Marker> markerlist = Set();
//   bool issearched = false;
//   bool work = false;
//   bool other = false;
//   bool home = false;
//   bool enableconfirm = false;

//   @override
//   void initState() {
//     _getUserLocation();
//     destinationMarkerIcon();
//     super.initState();
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
//         position: _initialPosition!,
//         // ?? LatLng(17.41287503151813, 78.43761731026065),
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
                  
//                   markers: markerlist,
//                   mapType: MapType.normal,
//                   initialCameraPosition: CameraPosition(
//                       target: _initialPosition ??
//                           LatLng(17.41287503151813, 78.43761731026065),
//                       zoom: 14),
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller = controller;
//                     // _controller.complete(controller);
//                   },
//                 ),
//               ],
//             ),
//       bottomNavigationBar: issearched
//           ? Container(
//               margin: EdgeInsets.fromLTRB(15, 26, 8, 20),
//               // height: 250,
//               height: context.heightTransformer(dividedBy: 2.5),
//               width: Get.width,
//               color: Colors.white,
//               child: SingleChildScrollView(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "SELECT DELIVERY LOCATION",
//                         style: TextStyle(
//                             color: Color(0xff1C1A19).withOpacity(0.5),
//                             fontSize: 16),
//                       ),
//                       SizedBox(
//                         height: height10 * 3.4,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.location_on_outlined),
//                               Text("Current Location",
//                                   style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.w400))
//                             ],
//                           ),
//                           Spacer(),
//                           ElevatedButton(
//                               onPressed: () {
//                                 // Get.to(SearchPlace());
//                                 _handlePressButton();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(80, 33),
//                                 primary: Color(0xffF67952).withOpacity(0.1),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(133),
//                                 ),
//                               ),
//                               child: Text(
//                                 "CHANGE",
//                                 style: TextStyle(
//                                     color: Color(0xff1C1A1980),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500),
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: height10,
//                       ),
//                       Text(
//                         "$place",
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Color(0xff1C1A19).withOpacity(0.5)),
//                       ),
//                       SizedBox(
//                         height: height10 * 3,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   work = false;
//                                   other = false;
//                                   home = true;
//                                   enableconfirm = true;
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(80, 33),
//                                 primary: home
//                                     ? Color(0xFFF67952)
//                                     : Color(0xffF67952).withOpacity(0.1),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(133),
//                                 ),
//                               ),
//                               child: Text(
//                                 "Home",
//                                 style: TextStyle(
//                                     color: home
//                                         ? Colors.white
//                                         : Color(0xff1C1A1980),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500),
//                               )),
//                           ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   work = true;
//                                   other = false;
//                                   home = false;
//                                   enableconfirm = true;
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(80, 33),
//                                 primary: work
//                                     ? Color(0xFFF67952)
//                                     : Color(0xffF67952).withOpacity(0.1),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(133),
//                                 ),
//                               ),
//                               child: Text(
//                                 "WORK",
//                                 style: TextStyle(
//                                     color: work
//                                         ? Colors.white
//                                         : Color(0xff1C1A1980),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500),
//                               )),
//                           ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   work = false;
//                                   other = true;
//                                   home = false;
//                                   enableconfirm = true;
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(80, 33),
//                                 primary: other
//                                     ? Color(0xFFF67952)
//                                     : Color(0xffF67952).withOpacity(0.1),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(133),
//                                 ),
//                               ),
//                               child: Text(
//                                 "other",
//                                 style: TextStyle(
//                                     color: other
//                                         ? Colors.white
//                                         : Color(0xff1C1A1980),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500),
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: height10 * 1.5,
//                       ),
//                       Center(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               enableconfirm
//                                   ? setState(() {
//                                       if (other == true ||
//                                           work == true ||
//                                           home == true) {
//                                         Get.to(HomePage());
//                                       }
//                                     })
//                                   : null;
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(205, 59),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(133)),
//                                 primary: enableconfirm
//                                     ? Color(0xFFF67952)
//                                     : Color(0xffF67952).withOpacity(0.1)),
//                             child: Text(
//                               "confirm",
//                               style: TextStyle(
//                                   color: enableconfirm
//                                       ? Colors.white
//                                       : Color(0xff1C1A1980),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500),
//                             )),
//                       ),
//                     ]),
//               ),
//             )
//           : Container(
//               margin: EdgeInsets.fromLTRB(15, 26, 8, 20),
//               // height: 250,
//               height: context.heightTransformer(dividedBy: 3.1),
//               width: Get.width,
//               color: Colors.white,
//               child: SingleChildScrollView(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "SELECT DELIVERY LOCATION",
//                         style: TextStyle(
//                             color: Color(0xff1C1A19).withOpacity(0.5),
//                             fontSize: 16),
//                       ),
//                       SizedBox(
//                         height: height10 * 3.4,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.location_on_outlined),
//                               Text("Current Location",
//                                   style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.w400))
//                             ],
//                           ),
//                           Spacer(),
//                           ElevatedButton(
//                               onPressed: () {
//                                 // Get.to(SearchPlace());
//                                 _handlePressButton();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(80, 33),
//                                 primary: Color(0xffF67952).withOpacity(0.1),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(133),
//                                 ),
//                               ),
//                               child: Text(
//                                 "CHANGE",
//                                 style: TextStyle(
//                                     color: Color(0xff1C1A1980),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500),
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: height10,
//                       ),
//                       Text(
//                         "$place",
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Color(0xff1C1A19).withOpacity(0.5)),
//                       ),
//                       SizedBox(
//                         height: height10 * 3,
//                       ),
//                       Center(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 Get.to(HomePage());
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(205, 59),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(133)),
//                                 primary: Color(0xFFF67952)),
//                             child: Text(
//                               "Confirm",
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                             )),
//                       ),
//                     ]),
//               ),
//             ),
//     );
//   }

//   Future<void> _handlePressButton() async {
//     Prediction? p = await PlacesAutocomplete.show(
//         context: context,
//         apiKey: kGoogleApiKey,
//         onError: (value) {
//           Get.snackbar(
//               value.errorMessage.toString(), value.errorMessage.toString());
//         },
//         mode: Mode.fullscreen,
//         language: 'en',
//         types: [""]);
//     displayPrediction(
//         p!); //!null check error if goes bacl--------------------------------------------
//   }

//   Future<void> displayPrediction(Prediction p) async {
//     GoogleMapsPlaces places = GoogleMapsPlaces(
//         apiKey: kGoogleApiKey,
//         apiHeaders: await const GoogleApiHeaders().getHeaders());
//     PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;
//     markerlist.clear();
//     markerlist.add(Marker(
//         icon: markerIcon,
//         markerId: MarkerId("0"),
//         position: LatLng(lat, lng),
//         infoWindow: InfoWindow(title: detail.result.name)));
//     setState(() {
//       place = detail.result.formattedAddress;
//       _controller.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(lat, lng), zoom: 15)));
//       issearched = true;
//       work = false;
//       other = false;
//       home = false;
//       enableconfirm = false;
//     });
//   }
// }
