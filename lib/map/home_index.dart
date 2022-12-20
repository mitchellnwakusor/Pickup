import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pickup_driver/global/global.dart';
import 'package:pickup_driver/main.dart';
import 'package:pickup_driver/map/models/user_info.dart';
import 'package:pickup_driver/services/firebase_services.dart';
import 'package:pickup_driver/services/providers.dart';
import 'package:pickup_driver/widgets/custom_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'assistants/assistent_method.dart';
import 'map_drawer.dart';

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

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  String userName = "";
  String userEmail = "";
  Position? driverCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;
  CustomColorTheme? customColorTheme;

  String statusText = "Now Offline";
  Color statusColor = Colors.grey;
  bool isDriverActive = false;
  bool openNavigationDrawer = true;


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

  FirebaseAuthentication authentication = FirebaseAuthentication();

  @override
  void initState()
  {
    super.initState();
    Future.delayed(Duration.zero,(){FirebaseRealtimeDatabase().fetchUserInfo(context,null);});
    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    userName = Provider.of<UserInfoProvider>(context).userInformation!.personalInfo!.firstName!;
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MapDrawer(
            user: Provider.of<UserInfoProvider>(context).userInformation!,
            name: userName,
            statusText: statusText,
            // email: userEmail,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
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
            Positioned(
              top: MediaQuery.of(context).size.height * 0.014,
              left: 16,
              child: GestureDetector(
                onTap: ()
                {
                  if (openNavigationDrawer){
                    sKey.currentState!.openDrawer();
                  }
                  else{

                    // refresh/refresh app state
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget));

                  }

                },
                child:  CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(
                    openNavigationDrawer ?  Icons.menu : Icons.close,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            // ui for online offline drivers
            statusText != "Now Online"
                ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color:  const Color(0xBFddddff),
              )
                : Container(),

            // button for driver online toggle
            Positioned(
                top: statusText !="Now Online"
                    ? MediaQuery.of(context).size.height * 0.45
                    : MediaQuery.of(context).size.height * 0.009,
                left: 0,
                right: 0,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){

                          if(isDriverActive != true)//Offline
                          {
                            driverIsOnlineNow();
                            upDateDriversLocationAtRealtime();

                            setState(() {
                              statusText = "Now Online";
                              isDriverActive = true;
                            });

                            //display Toast
                            Fluttertoast.showToast(msg: "You are Online Now");
                          }

                          else//online
                          {
                            driverIsOfflineNow();

                            setState(() {
                              statusText = "Now Offline";
                              isDriverActive = false;
                            });

                            //display Toast
                            Fluttertoast.showToast(msg: "You are Offline Now");
                          }
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
        ),
      ),);

  }
 //update driver current location in realtime database when driver goes online
  driverIsOnlineNow() async{
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    //set location of all drivers online using driver id
    Geofire.initialize( "activeDrivers");
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

    print( currentFirebaseUser!.displayName);
  }

  upDateDriversLocationAtRealtime(){

    streamSubscriptionPosition = Geolocator
        .getPositionStream()
        .listen((Position position) {
          driverCurrentPosition = position;

          if(isDriverActive == true){
            Geofire.setLocation(
                currentFirebaseUser!.uid,
                driverCurrentPosition!.latitude,
                driverCurrentPosition!.longitude
            );
          }

          LatLng latLng = LatLng(
              driverCurrentPosition!.latitude,
              driverCurrentPosition!.longitude
          );

          newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));

    });
  }
  driverIsOfflineNow(){
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("dUser")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
    
    Future.delayed(const Duration(milliseconds: 2000), 
      ()
        {
          SystemChannels.platform.invokeListMethod("SystemNavigator.pop");

        }
    );
  }

}
