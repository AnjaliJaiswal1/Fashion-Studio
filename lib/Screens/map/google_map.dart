import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../../main.dart';
import '../home_page.dart';

const kGoogleApiKey = 'AIzaSyD2dcjAKRXXxaLn2WeatT69_RsW_loOOEg';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController _controller;
  LatLng? _initialPosition;
  StreamController<LatLng> streamController = StreamController();
  String? place;
  bool issearched = false;
  bool work = false;
  bool other = false;
  bool home = false;
  bool enableconfirm = false;
  late BitmapDescriptor markerIcon;
  bool changepress=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == await LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      place = placemark[3].locality.toString() +
          ", " +
          placemark[3].name.toString();
    });
    streamController.add(_initialPosition as LatLng);
  }

  void getloc(double lat, double lng) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lng);
    place = placemark[0].name.toString() +
        "," +
        placemark[0].subLocality.toString() +
        "," +
        placemark[0].locality.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        GoogleMap(
          onCameraMove: (CameraPosition pos) {
            streamController.add(pos.target);
          },
          initialCameraPosition: CameraPosition(
              target: _initialPosition ??
                  LatLng(17.41287503151813, 78.43761731026065),
              zoom: 16),
          onMapCreated: (controller) {
            _controller = controller;
          },
        ),
        // Center(child: SvgPicture.asset("assets/map/marker.svg"),),
        Positioned(
          top: Get.height / 4.5,
          left: Get.width / 3,
          child: SvgPicture.asset("assets/map/marker.svg"),
        ),
        Positioned(
          top: Get.height / 5,
          left: Get.width / 6,
          child:Column(children: [
            Text("Order will be delivery herejgu iuhiuhkjh iu iuhi",style: TextStyle(color: Colors.white),)
          ]),
        ),
        Positioned(
          top: Get.height / 5,
          left: Get.width / 6,
          child: Stack(children: [
            SvgPicture.asset("assets/map/info.svg"),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("    Order will be delivery here ",style: TextStyle(color: Colors.white,fontSize: 16),),
                    Text("   Place the pin accurately on the map",style: TextStyle(color: Colors.white,fontSize:12),)
                  ],
                ),
              ),
            )
          ],)
        ),
      ]),
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
                    height: height10 * 4,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/map/location.svg"),
                      // Icon(Icons.location_on_outlined),
                      Text("Current Location",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400)),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            // Get.to(SearchPlace());
                            changepress=true;
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "CHANGE",
                              style: TextStyle(
                                  color: Color(0xff1C1A19).withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
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
                        getloc(
                            snapshot.data!.latitude, snapshot.data!.longitude);
                        return Text(
                          "$place",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff1C1A19).withOpacity(0.5)),
                        );
                      } else {
                        return Text('null');
                      }
                    },
                  ),
                  SizedBox(
                    height: height10 * 2.5,
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
                            minimumSize: Size(93, 35),
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
                                color:
                                    home ? Colors.white :  Color(0xff1C1A19).withOpacity(0.25),
                                fontSize: 14,
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
                            minimumSize: Size(93, 33),
                            primary: work
                                ? Color(0xFFF67952)
                                : Color(0xffF67952).withOpacity(0.1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(133),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Work",
                              style: TextStyle(
                                  color:
                                      work ? Colors.white : Color(0xff1C1A19).withOpacity(0.25),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
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
                            minimumSize: Size(93, 35),
                            primary: other
                                ? Color(0xFFF67952)
                                : Color(0xffF67952).withOpacity(0.1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(133),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Others",
                              style: TextStyle(
                                  color: other
                                      ? Colors.white
                                      :  Color(0xff1C1A19).withOpacity(0.25),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height10 * 5.6,
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
                                  : Color(0xff1C1A19).withOpacity(0.25),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              )),
            )
          : Container(
              margin: EdgeInsets.fromLTRB(15, 26, 8, 20),
              height: context.heightTransformer(dividedBy: 3),
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
                          SvgPicture.asset("assets/map/location.svg"),
                          Text("Current Location",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w400)),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "CHANGE",
                                  style: TextStyle(
                                      color: Color(0xff1C1A19).withOpacity(0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: height10 * 1.3,
                      ),
                      StreamBuilder<LatLng>(
                        stream: streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            getloc(snapshot.data!.latitude,
                                snapshot.data!.longitude);

                            return Text(
                              "$place",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff1C1A19).withOpacity(0.5)),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      Text(
                        "Deliver to door",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff1C1A19).withOpacity(0.5)),
                      ),
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
        mode: Mode.overlay,
        language: 'en',
        types: [""]);
    if (p != null) {
      displayPrediction(p);
    } //!null check error if goes bacl--------------------------------------------
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

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
