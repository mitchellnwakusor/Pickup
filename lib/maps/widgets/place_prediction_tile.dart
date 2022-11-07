import 'package:flutter/material.dart';
import 'package:pickup_driver/global/map_key.dart';
import 'package:pickup_driver/maps/assistants/request_method.dart';
import 'package:pickup_driver/maps/models/direction.dart';
import 'package:pickup_driver/maps/models/predicted_places.dart';
import 'package:pickup_driver/maps/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';


class PlacePredictionTileDesign extends StatelessWidget {

  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Setting destination....",
        ),
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestMethod.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occurred, Failed. No Response."){

      return;
    }

    if(responseApi["status"] =="OK"){
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];
      directions.locationId = placeId;

      Provider.of<AppInfo>(context, listen: false).upDateDropOffLocationAddress(directions);

      Navigator.pop(context, "obtainedDropOff");

    }
  }


  @override
  Widget build(BuildContext context) {
    
    return ElevatedButton(
        onPressed: (){
          getPlaceDirectionDetails(predictedPlaces!.place_id, context);

        },
      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const Icon(
                Icons.add_location,
                color: Colors.grey,
              ),

              const SizedBox(width: 14.0,),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 2.0,),

                      Text( predictedPlaces!.main_text!,
                      overflow:  TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height:2.0 ,),

                      Text( predictedPlaces!.secondary_text!,
                        overflow:  TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height:8.0 ,),

                    ],
                  ),

              ),
            ],
          ),
        ),
    );
  }
}
