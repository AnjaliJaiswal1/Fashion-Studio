import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_task1/main.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';

const kGoogleApiKey = '';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Set<Marker> Markerlist = Set();
  //  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller;
  String hintplace = "Search palce";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(17.41287503151813, 78.43761731026065),
                    zoom: 15),
                markers: Markerlist,
              ),
              InkWell(
                  onTap: () {
                    _handlePressButton();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    height: height10 * 5.7,
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(                        children: [
                          Icon(Icons.search_rounded),
                          SizedBox(
                            width: 20,
                          ),
                          //--------------------------------------------------------------------//
                          Text(
                            hintplace,
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                            maxLines: 4,
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.close_rounded))
                        ],
                      ),
                    ),
                  )),
            ],
          )),
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
    displayPrediction(p!);
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    Markerlist.clear();
    Markerlist.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));
    setState(() {
      hintplace = detail.result.formattedAddress.toString();

      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15)));
    });
  }
}
