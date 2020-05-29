import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asthmaalert/pages/home.dart';
import 'package:asthmaalert/widgets/custom_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String password;
  String username;

  final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> registerUser() async{
    AuthResult user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser _user = await _auth.currentUser();
    await _firestore.collection('users').document(username).setData({
      'username': username,
      'email' : email,
      'uid' : _user.uid,
    });

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
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(
                  'assets/images/asthmaalert.png'
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
            CustomButton(
              text: 'Register',
              callback: () async {
                await registerUser();
              },
            )
          ],
        ),
      ),
    );
  }
}
