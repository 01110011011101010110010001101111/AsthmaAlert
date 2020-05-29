import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  final FirebaseUser user;

  const Profile({Key key, this.user}) : super(key: key);


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
