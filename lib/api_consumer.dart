import 'dart:typed_data';
import 'package:engage_verse/global.dart';
import 'package:http/http.dart' as http;


class ApiClient
{
  Future<Uint8List> removeImageBgApi(String imagePath) async
  {
    //initialize sending request
    var requestApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.remove.bg/v1.0/removebg")
    );

    //define which image file to send
    requestApi.files.add(
      await http.MultipartFile.fromPath(
        "image_file",
        imagePath
        )
    );

    //communicate with the help of api key || api header
    requestApi.headers.addAll(
      {
        "X-API-Key": removeBgApiKey
      }
    );

    //send request and recieve response
    final responseFromApi = await requestApi.send();


    if(responseFromApi.statusCode == 200)
    {
      http.Response getTranparentImageFromResponse = await http.Response.fromStream(responseFromApi);
      return getTranparentImageFromResponse.bodyBytes;
    }
    else
    {
      throw Exception("Error Occured:: " + responseFromApi.statusCode.toString());
    }
  }


}