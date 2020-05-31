import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';



class LocationServer {

  // ignore: close_sinks
  final _locationController = StreamController<String>();


  Stream<String> get stream => _locationController.stream;


  LocationServer(String email){
    Timer.periodic(Duration(seconds: 1), (t) async {
      // add the http status code = 200
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String lat1 = position.latitude.toString().substring(0,);
      String long1 = position.longitude.toString().substring(0,5);
    //  var response = await http.get('https://asthmaalert.herokuapp.com/alert?user=$email&lat=$lat1&lon=$long1');
    //  var response = await http.get('https://asthmaalert.herokuapp.com/alert?user=a@com&lat=42.336509&lon=-71.202483');
     // String new_txt = buildResponse(response.body.toString());

      _locationController.add('Latitude: ${position.latitude}\nLongitutde: ${position.longitude}');
    });

  }
}

String buildResponse(String res) {
  String response = '';
  Map temp = jsonDecode(res);
  if (temp['Alert']){
    response += 'ALERT! ';
    response += temp['Message'];
  } else {
    response += 'No Alert';
  }
  return response;
}