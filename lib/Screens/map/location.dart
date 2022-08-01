import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_task1/Screens/map/search.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import '../../main.dart';

const kGoogleApiKey = '';
class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller;
  CameraPosition? cameraPosition;

  LatLng? _initialPosition;
  // Set<Marker> markers = Set();
  late BitmapDescriptor markerIcon;
  String? place;
  
  Set<Marker> markerlist = Set();

  // late Position currentposition= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
            LatLng(_initialPosition!.latitude, _initialPosition!.longitude),
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

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
      backgroundColor: Colors.white,
      body: _initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  markers: markerlist,
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: _initialPosition??LatLng(17.41287503151813, 78.43761731026065), zoom: 14),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    // _controller.complete(controller);
                  },
                ),
              ],
            ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(15, 26, 8, 20),
        height: 250,
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
                      color: Color(0xff1C1A19).withOpacity(0.5), fontSize: 16),
                ),
                SizedBox(
                  height: height10 * 3.4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Text("Current Location",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400))
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(SearchPlace());
                          // _handlePressButton();
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
                Text(
                  "$place",
                  style: TextStyle(
                      fontSize: 16, color: Color(0xff1C1A19).withOpacity(0.5)),
                ),
                SizedBox(
                  height: height10 * 3,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          //  addMarkers();
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
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    displayPrediction(p!);
  }
  Future<void>displayPrediction(Prediction p)async{
    GoogleMapsPlaces places=GoogleMapsPlaces(apiKey: kGoogleApiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail= await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    markerlist.clear();
    markerlist.add(Marker(
      icon: markerIcon,
        markerId: MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));
    setState(() {
      place=detail.result.formattedAddress;
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng),zoom: 15)));
    });
  }
}
