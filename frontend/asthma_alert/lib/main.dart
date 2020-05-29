import 'package:flutter/material.dart';
import 'package:asthmaalert/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asthmaalert/pages/home.dart';

void main() {
  runApp(MyApp());
}

Widget getAuthState(){
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getUser() async{
    return _auth.currentUser();
  }

  getUser().then((user) {
    if (user != null) {
      return Home(index: 1, user: user,);

    }
    return Login();
  });
  return Login();
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asthma Alert',
      theme: ThemeData.light(),
      home: getAuthState(),
    );
  }
}