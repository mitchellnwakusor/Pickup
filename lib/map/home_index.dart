import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:pickup_driver/global/global.dart';
import 'package:pickup_driver/widgets/custom_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'assistants/assistent_method.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {


  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String userName = "";
  String userEmail = "";
  Position? driverCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;
  CustomColorTheme? customColorTheme;

  String statusText = "Now Offline";
  Color statusColor = Colors.grey;
  bool isDriverActive = false;


  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethod.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);

    userEmail ="JoneDoe@gmail.com";
    userName = "John Doe";
  }

  @override
  void initState()
  {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          GoogleMap(
            mapType:  MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locateDriverPosition();
            },
          ),

          //ui for online offline drivers
          statusText != "Now Online"
              ? Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color:  Color(0xBFddddff),
            )
              : Container(),

          // button for driver online toggle
          Positioned(
              top: statusText !="Now Online"
                  ? MediaQuery.of(context).size.height * 0.45
                  : 25,
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        driverIsOnlineNow();
                      },
                    style: ElevatedButton.styleFrom(
                      primary: customColorTheme?.btnColor,
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                    ),
                      child: statusText != "Now Online"
                          ? Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.phonelink_ring,
                        color: Color(0xBFddddff),
                        size: 26.0,
                      ),
                  ),
                ],
              ),
          ),
        ],
      );

  }
 //update driver current location in realtime database when driver goes online
  driverIsOnlineNow() async{
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    //set location of all drivers online using driver id
    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("dUser")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.set("idle"); // searching for ride request
    ref.onValue.listen((event) { });
  }
}
