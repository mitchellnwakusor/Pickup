import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestMethod{

  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200) // successful
          {
        String resData = httpResponse.body; //json format


        var decodeResponseData = jsonDecode(resData);
        return decodeResponseData;
      }

      return "Error Occurred, Failed. No Response.";
    }

    catch (exp){
      return "Error Occurred, Failed. No Response.";
    }
  }

}