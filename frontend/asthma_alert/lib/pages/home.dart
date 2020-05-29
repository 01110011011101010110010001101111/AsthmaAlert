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
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
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
              icon: Icon(Icons.message, color: Colors.white,),
              child: Text(
                'Messages', style: TextStyle(
                  color: Colors.white
              ),
              ),
            ),
            Tab(
              icon: Icon(Icons.near_me, color: Colors.white,),
              child: Text(
                'Connect', style: TextStyle(
                  color: Colors.white
              ),
              ),
            ),
            Tab(
              icon: Icon(Icons.person, color: Colors.white),
              child: Text(
                'Profile', style: TextStyle(
                  color: Colors.white
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
