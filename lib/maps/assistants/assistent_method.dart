import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickup_driver/global/map_key.dart';
import 'package:pickup_driver/maps/assistants/request_method.dart';
import 'package:pickup_driver/maps/infoHandler/app_info.dart';
import 'package:pickup_driver/maps/models/direction.dart';
import 'package:pickup_driver/maps/models/direction_details_info.dart';
import 'package:provider/provider.dart';


class AssistantMethod {

  static Future<String> searchAddressForGeographicCoOrdinates (Position position, context) async {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";


    String humanReadableAddress ="";

    var requestResponse = await RequestMethod.receiveRequest(apiUrl);


    if (requestResponse != "Error Occurred, Failed. No Response."){

     humanReadableAddress = requestResponse["results"][0]["formatted_address"];

     Directions userPickUpAddress= Directions();
     userPickUpAddress.locationLongitude=position.longitude;
     userPickUpAddress.locationLatitude=position.latitude;
     userPickUpAddress.locationName=humanReadableAddress;

     Provider.of<AppInfo>(context, listen: false).upDatePickupLocationAddress(userPickUpAddress);

    }

    return humanReadableAddress;

  }

  static Future<DirectionsDetailsInfo?> obtainOrinToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async {
    String urlOrinToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";
    var responseDirectionApi = await RequestMethod.receiveRequest(urlOrinToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response."){
      return null;
    }

  DirectionsDetailsInfo directionDetailsInfo = DirectionsDetailsInfo();
  directionDetailsInfo.encoded_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

  directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
  directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

  directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
  directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

  return directionDetailsInfo;
  }

}
