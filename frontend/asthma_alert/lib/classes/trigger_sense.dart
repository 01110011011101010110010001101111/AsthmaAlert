//import 'dart:async';
//import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:http/http.dart' as http;
//import 'package:geolocator/geolocator.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:convert';
//
//
//
//
//
//class TriggerSensor {
//
//  // ignore: close_sinks
//  final _triggerController = StreamController<String>();
//
//
//  Stream<String> get stream => _triggerController.stream;
//
//
//  TriggerSensor(String email) {
//    Firestore _firestore = Firestore.instance;
//
//    Timer.periodic(Duration(seconds: 5), (t) async {
//
//      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//      String lat1 = position.latitude.toString().substring(0,5);
//      String long1 = position.longitude.toString().substring(0,5);
//      var response = await http.get('https://asthmaalert.herokuapp.com/alert?user=$email&lat=$lat1&lon=$long1');
//
//      _triggerController.add(jsonDecode(response.body.toString()));
//    });
//
//  }
//}
//
//
//String getStr(String what) {
//  Map teemp = jsonDecode(what);
//
//  String newStr = '';
//  teemp.forEach((key, value) {
//    if (value) {
//      newStr += key + ',';
//    }
//  });
//  return newStr;
//
//}