import 'package:flutter/material.dart';
import 'package:pickup_driver/global/map_key.dart';
import 'package:pickup_driver/maps/assistants/request_method.dart';
import 'package:pickup_driver/maps/widgets/place_prediction_tile.dart';

import 'models/predicted_places.dart';


class SearchPlacesScreen extends StatefulWidget {


  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}



class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList =[];
  void findPlaceAutoCompleteSearch(String inputText) async {

    if (inputText.length > 1)  // more than one search text must be typed
    {
      String urlAutocompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:NG";

     var responseAutoCompleteSearch= await RequestMethod.receiveRequest(urlAutocompleteSearch);

     if (responseAutoCompleteSearch == "Error Occurred, Failed. No Response."){

       return;
     }

     if (responseAutoCompleteSearch["status"]=="OK"){

       var placePredictions= responseAutoCompleteSearch["predictions"];

       var placePredictionList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

      setState((){
        placesPredictedList = placePredictionList;
      });
     }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        children: [

          //search place ui
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              boxShadow: [BoxShadow(
                color: Colors.white54,
                blurRadius: 8,
                spreadRadius: 0.5,
                offset: Offset(0.7,0.7
                ),
              ),],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [

                  const SizedBox(height: 25.0,),

                  Stack(
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),

                      const Center(
                        child: Text(
                          "Search & set Drop Location ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0,),

                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 18.0,),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped){

                              findPlaceAutoCompleteSearch(valueTyped);

                            },
                            decoration: const InputDecoration(
                              hintText: "Search here...",
                              fillColor: Colors.white,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 8.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          //display place prediction results

          (placesPredictedList.length > 0)
              ? Expanded(
            child: ListView.separated(
              itemCount: placesPredictedList.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index){
                return PlacePredictionTileDesign(
                  predictedPlaces: placesPredictedList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index ){
               return const Divider(
                  height: 1,
                  color: Colors.white,
                  thickness: 1,
                );
              },
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
