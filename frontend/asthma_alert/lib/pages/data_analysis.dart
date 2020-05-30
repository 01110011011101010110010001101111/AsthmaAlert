import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asthmaalert/widgets/custom_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class DataAnalysis extends StatefulWidget {
  final FirebaseUser user;

  const DataAnalysis({Key key, this.user}) : super(key: key);

  @override
  _DataAnalysisState createState() => _DataAnalysisState();
}

class _DataAnalysisState extends State<DataAnalysis> {
  String most_suscp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/graph.png'),

            ),
            SizedBox(
                height: 5,
            ),
            CustomButton(
              text: 'Acquire Data',
              callback: ()async{
                var response = await http.get('https://asthmaalert.herokuapp.com/possibleNewTriggers?user=a@com');
                setState(() {
                  most_suscp = response.body.toString();
                });
              },
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.blueAccent
              ),
              child: Column(
                children: <Widget>[
                  Text('Prediction', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20
                  ),),
                  Divider(thickness: 13,),
                  SizedBox(height: 4,),
                  Row(
                    children: <Widget>[
                      Text('You are most likely to be affected by: '),
                      Text(most_suscp, style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  )

                ],
              ),
            )

          ],
        ),
      )
    );
  }
}
