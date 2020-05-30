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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.width - 10,
                child: MaterialButton(
                  shape: CircleBorder(side: BorderSide(width: 15, color: Colors.redAccent, style: BorderStyle.solid)),
                  child: Text("Emergency Alert", style: TextStyle(
                      fontSize: 20
                  ),),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: (){
                    showDialog(context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Are You Sure You Want to Activate Emergency?'),
                            actions: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Divider(),
                                  RaisedButton(
                                    child: Text('Cancel'),
                                    elevation: 12,
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(width: 10,),
                                  RaisedButton(
                                    child: Icon(Icons.volume_up),
                                    color: Colors.redAccent,
                                    elevation: 12,
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                    );

                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                child: MaterialButton(
                  shape: CircleBorder(side: BorderSide(width: 10, color: Colors.lightBlueAccent, style: BorderStyle.solid)),
                  child: Text("Hold to Confirm Safety", style: TextStyle(
                    fontSize: 20,
                  ),
                    textAlign:TextAlign.center,
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: (){},
                ),
              ),


            ],
          ),
        )
    );
  }
}
