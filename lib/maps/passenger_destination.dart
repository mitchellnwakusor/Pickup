import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:pickup_driver/maps/widgets/progress_dialog.dart';
import 'package:pickup_driver/maps/assistants/assistent_method.dart';
import 'package:pickup_driver/maps/widgets/map_drawer.dart';
import 'package:pickup_driver/maps/infoHandler/app_info.dart';
import 'package:pickup_driver/maps/search_places_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickup_driver/services/firebase_services.dart';
import 'package:pickup_driver/services/providers.dart';
import 'package:provider/provider.dart';

class PassengerDestination extends StatefulWidget {
  const PassengerDestination({Key? key}) : super(key: key);

  @override
  State<PassengerDestination> createState() => _PassengerDestinationState();
}

class _PassengerDestinationState extends State<PassengerDestination> {

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> polyLineCoordinateList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circleSets = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;




  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethod.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
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
  Widget build(BuildContext context)
  {
    return  Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MapDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [

          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circleSets,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;



              setState(() {
                bottomPaddingOfMap = 240;
              });

              locateUserPosition();
            },
          ),

          //custom hamburger button for drawer
          Positioned(
            top: 30,
            left: 14,
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
                backgroundColor: Colors.grey,
                child: Icon(
                openNavigationDrawer ?  Icons.menu : Icons.close,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      //from
                      Row(
                        children: [
                          const Icon(Icons.add_location_alt_outlined, color: Colors.grey,),
                          const SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context, listen: true).userPickupLocation != null
                                    ? (Provider.of<AppInfo>(context).userPickupLocation!.locationName!).substring(0,24) + "..."
                                    : "not getting address",
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 16.0),

                      //to
                      GestureDetector(
                        onTap: () async
                        {
                          //go to search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));


                          if(responseFromSearchScreen == "obtainedDropOff")
                          {

                            setState((){
                              openNavigationDrawer = false;
                            });

                            //draw routes - draw polyline

                            await drawPolyLineFromOriginToDestination();


                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.add_location_alt_outlined, color: Colors.grey,),
                            const SizedBox(width: 12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                      ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : "Where to go?",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 16.0),

                      ElevatedButton(
                        child: const Text(
                          "Request a Ride",
                        ),
                        onPressed: ()
                        {

                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickupLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    
    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    //progress dialog before destination route
    showDialog(
        context: context,
        builder: (BuildContext context)=> ProgressDialog(message: "Please wait...",),
    );

    var directionDetailsInfo = await AssistantMethod.obtainOrinToDestinationDirectionDetails(originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are the points = ");
    print(directionDetailsInfo!.encoded_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsList = pPoints.decodePolyline(directionDetailsInfo!.encoded_points!);

    polyLineCoordinateList.clear();

  if (decodedPolylinePointsList.isNotEmpty)
  {
    decodedPolylinePointsList.forEach((PointLatLng pointLatLng)
    {
      polyLineCoordinateList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    });
  }
polyLineSet.clear();

  setState((){

    Polyline polyline = Polyline(
        color: Colors.blueAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLineCoordinateList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true
    );

    polyLineSet.add(polyline);
  });

  LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
    boundsLatLng = LatLngBounds(
      southwest: destinationLatLng,
      northeast: originLatLng
    );

    }
    else  if (originLatLng.longitude > destinationLatLng.longitude )
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:  LatLng(destinationLatLng.latitude, originLatLng.longitude)
      );

    }
    else  if (originLatLng.latitude > destinationLatLng.latitude)
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast:  LatLng(originLatLng.latitude, destinationLatLng.longitude)
      );
    }
    else {
      boundsLatLng = LatLngBounds(
          southwest: originLatLng,
          northeast: destinationLatLng
      );
    }
    newGoogleMapController?.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 60));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );


  Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
    infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
    position: destinationLatLng,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  );

  setState((){
    markersSet.add(originMarker);
    markersSet.add(destinationMarker);
  });

  Circle originCircle = Circle(
      circleId: const CircleId("originID"),
    fillColor: Colors.greenAccent,
    radius: 17,
    strokeWidth:3 ,
    strokeColor: Colors.grey,
    center: originLatLng,

  );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.blueAccent,
      radius: 10,
      strokeWidth:3 ,
      strokeColor: Colors.grey,
      center: destinationLatLng,

    );

    setState((){
      circleSets.add(originCircle);
      circleSets.add(destinationCircle);
    });
  }

}

