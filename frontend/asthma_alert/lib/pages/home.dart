import 'package:asthmaalert/pages/alert_page.dart';
import 'package:asthmaalert/pages/data_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asthmaalert/pages/login.dart';
import 'package:asthmaalert/pages/profile.dart';

class Home extends StatefulWidget {
  final int index;
  final FirebaseUser user;

  const Home({ Key key, this.index, this.user }): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: widget.index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Hero(
          tag: 'Title',
          child: Image(
            image: AssetImage('assets/images/asthmaalert.png')
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black,),
            onPressed: (){


              showDialog(context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.not_interested),
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: (){
                            _auth.signOut();
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Login()
                                )
                            );
                            },
                        )
                      ],
                    );
                  }
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            DataAnalysis(user: widget.user,),
            AlertPage(),
            Profile(user:widget.user),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.black12,
          unselectedLabelColor: Colors.black38,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.poll, color: Colors.black,),
              child: Text(
                'Data Analysis',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.volume_up, color:  Colors.black,),
              child: Text(
                'Alert', style: TextStyle(
                color: Colors.black
              ),
              ),
            ),
            Tab(
              icon: Icon(Icons.person, color: Colors.black,),
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
