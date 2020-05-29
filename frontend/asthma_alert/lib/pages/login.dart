import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asthmaalert/widgets/custom_buttons.dart';
import 'package:asthmaalert/pages/home.dart';
import 'package:asthmaalert/pages/registration.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<FirebaseUser> getUser() async{
    return _auth.currentUser();
  }

  Future<void> signInUser() async{
    AuthResult user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser temp = await getUser();
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(
            builder: (BuildContext context) => Home(index: 1, user: temp,)
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (BuildContext context) => Home(index: 1, user: user,)
            )
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    hintText: 'Email',
                    fillColor: Colors.deepPurpleAccent
                )
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: 'Login',
              callback: () async{
                await signInUser();
              } ,
            ),
            SizedBox(
              height: 15,
            ),

            CustomButton(
              text: 'Register',
              callback: (){
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Registration()
                    )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

