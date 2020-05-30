import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asthmaalert/pages/home.dart';
import 'package:asthmaalert/widgets/custom_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asthmaalert/pages/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String password;
  String username;
  String emergencyContact;
  Map<String, bool> factors = {'humidity': false, 'elevation': false, 'aq': false, 'temp': false, 'pollen': false};
  bool idk = false;

  final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async{

    String new_str = '';
    factors.forEach((key, value) {
      if (value && key != 'pollen') {
        new_str += key + ',';
      }
      new_str = new_str.substring(0, new_str.length - 1);
    });

    AuthResult user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser _user = await _auth.currentUser();
    await _firestore.collection('users').document(_user.uid).setData({
      'username': username,
      'email' : email,
      'emergency': emergencyContact,
      'uid' : _user.uid,
      'factors': factors
    });

    print(new_str);

    var response = await http.get('https://asthmaalert.herokuapp.com/newUser?user=$email&triggers=$new_str');
    print(response.body);

    FirebaseUser temp = await getUser();
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(
            builder: (BuildContext context) => Home(index: 1, user: temp,)
        )
    );
  }

  Future<FirebaseUser> getUser() async{
    return _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Register'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Login()
              )
            );
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Container(

        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'Title',
              child: Image(
                  image: AssetImage('assets/images/asthmaalert.png')
              ),
            ),

            TextField(
                onChanged: (value) => username = value,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  hintText: 'Enter Your Username',
                )
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  hintText: 'Enter Your Email',
                )
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => password = value,
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Enter Your Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                onChanged: (value) => emergencyContact = value,
                decoration: InputDecoration(
                  icon: Icon(Icons.contact_phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  hintText: 'Enter Your Emergency Contact Number',
                )
            ),
            SizedBox(
              height: 15,
            ),
            Divider(thickness: 5,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('What commonly triggers your asthma attacks?', style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: factors['humidity'],
                      onChanged: (bool value) {
                        setState(() {
                          factors['humidity'] = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Humidity')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: factors['elevation'],
                      onChanged: (bool value) {
                        setState(() {
                          factors['elevation'] = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Altitude')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: factors['aq'],
                      onChanged: (bool value) {
                        setState(() {
                          factors['aq'] = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Air Quality')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: factors['temp'],
                      onChanged: (bool value) {
                        setState(() {
                          factors['temp'] = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Temperature')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: factors['pollen'],
                      onChanged: (bool value) {
                        setState(() {
                          factors['pollen'] = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Pollen')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: idk,
                      onChanged: (bool value) {
                        setState(() {
                          idk = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("I don't know")
                  ],
                )
              ],
            ),

            CustomButton(
              text: 'Register',
              callback: () async {
                if (idk){
                  setState(() {
                    factors['pollen'] = true;
                    factors['elevation'] = true;
                    factors['aq'] = true;
                    factors['humidity'] = true;
                    factors['temp'] = true;
                  });
                }
                await registerUser();
              },
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      )
    )
    );
  }
}
