import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertPage extends StatefulWidget {
  final FirebaseUser user;

  const AlertPage({Key key, this.user}) : super(key: key);

  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
