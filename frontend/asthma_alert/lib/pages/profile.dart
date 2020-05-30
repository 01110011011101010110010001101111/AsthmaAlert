import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Profile extends StatefulWidget {
  final FirebaseUser user;

  const Profile({Key key, this.user}) : super(key: key);


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Firestore _firestore = Firestore.instance;


  Future<Map<String, dynamic>> getGroupInfo() async {
    var document = await _firestore.collection("users").document(widget.user.uid).get();
    return document.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,

                      colors: [
                        Colors.white,
                        Colors.lightBlueAccent
                      ]
                    )
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  child: FutureBuilder(
                    future: getGroupInfo(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                        return Text(snapshot.data['username']);
                      }
                      return Text('Loading');
                    },
                  )
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
