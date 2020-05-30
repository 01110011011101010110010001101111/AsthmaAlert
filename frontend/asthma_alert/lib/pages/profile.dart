import 'package:asthmaalert/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asthmaalert/classes/location.dart';



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
      body: Container(
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
                  height: MediaQuery.of(context).size.height-10,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  child: FutureBuilder(
                    future: getGroupInfo(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(left: 30, top: 100 , right: 30, bottom: 100),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshot.data['username'], style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 48
                              ),
                              ),
                              Divider(color: Colors.lightBlueAccent,
                              thickness: 5,),
                              SizedBox(height: 10,),
                              Column(
                                children: <Widget>[
                                  Text(snapshot.data['emergency'], style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(height: 15,),
                                  Text('EMERGENCY CONTACT')
                                ],
                              ),
                              Divider(thickness: 3,),
                              SizedBox(height: 15,),
                              Row(
                                children: <Widget>[
                                  Text('Email : ',textAlign: TextAlign.center, style: TextStyle(
                                      fontSize: 18
                                  ),),
                                  Text(
                                    snapshot.data['email'], style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22
                                  ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),

                            ],
                          ),
                        );
                      }
                      return Text('Loading');
                    },
                  )
                ),
    );
  }
}
