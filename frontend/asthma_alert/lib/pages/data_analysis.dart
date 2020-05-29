import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataAnalysis extends StatefulWidget {
  final FirebaseUser user;

  const DataAnalysis({Key key, this.user}) : super(key: key);

  @override
  _DataAnalysisState createState() => _DataAnalysisState();
}

class _DataAnalysisState extends State<DataAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
