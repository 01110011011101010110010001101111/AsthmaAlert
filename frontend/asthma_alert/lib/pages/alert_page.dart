import 'package:asthmaalert/classes/trigger_sense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asthmaalert/classes/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:asthmaalert/pages/home.dart';
import 'package:asthmaalert/main.dart';
import 'package:http/http.dart' as http;
import 'package:asthmaalert/classes/trigger_sense.dart';

class AlertPage extends StatefulWidget {
  final FirebaseUser user;

  const AlertPage({Key key, this.user}) : super(key: key);

  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  Map<String, dynamic> number;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  Future<Map<String, dynamic>> getGroupInfo() async {
    var document = await Firestore.instance.collection("users").document(widget.user.uid).get();
    return document.data;
  }


  @override
  void initState() {
    // TODO: implement initState
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_logo');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    super.initState();
  }


  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => Home(index: 1, user: widget.user,)));
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(index: 1, user: widget.user,),
                    ),
                  );
                },
              )
            ],
          ),
    );
  }
  void _showNotification() async {
    await _demoNotification();
  }


  Future<void> _demoNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, 'Hello, buddy',
        'A message from flutter buddy', platformChannelSpecifics,
        payload: 'test oayload');
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                width: MediaQuery.of(context).size.width,
                height: 130,
                decoration:BoxDecoration(
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
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Text('Alerts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    StreamBuilder(
                      stream: LocationServer(widget.user.email).stream,
                      builder: (context,snapshot) {
                        if(!snapshot.hasData){
                          return Row(  mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(backgroundColor: Colors.white,)
                            ],
                          );
                        } else if (snapshot.hasError){
                          return Row(  mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(backgroundColor: Colors.white,)
                            ],
                          );
                        }
                        return  Column(children: <Widget>[
                        Text('${snapshot.data[0].toString()}',
                              style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            )
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('${snapshot.data[1].toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),)
                        ],
                        );
                      },
                    ),
                  ],
                ),

              ),
              SizedBox(height: 30,),
              Container(
                width: 200,
                height: 200,
                child: MaterialButton(
                  shape: CircleBorder(side: BorderSide(width: 15, color: Colors.redAccent, style: BorderStyle.solid)),
                  child: Text("Emergency Alert", style: TextStyle(
                      fontSize: 20
                  ),),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () async{
                    number = await getGroupInfo();
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
                                    onPressed: () async{
                                      var response = await http.get('https://asthmaalert.herokuapp.com/newAttack?user=a@com&lat=48.764&lon=72.23');
                                      launch("tel://${number['emergency']}");
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
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 3,
                child: MaterialButton(
                  shape: CircleBorder(side: BorderSide(width: 10, color: Colors.lightBlueAccent, style: BorderStyle.solid)),
                  child: Text("Hold to Confirm Safety", style: TextStyle(
                    fontSize: 20,
                  ),
                    textAlign:TextAlign.center,
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () async {
                    var response = await http.get('https://asthmaalert.herokuapp.com/newAttack?user=a@com&lat=48.764&lon=72.23');
                    _showNotification();
                  },
                ),
              ),


            ],
          ),
        )
    );
  }
}
