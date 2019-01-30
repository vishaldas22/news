import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/login.dart';
import 'package:news/ui/discover.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

//  var _currentStatus = 'Unknown';
//  Connectivity connectivity;
//  StreamSubscription<ConnectivityResult> subscription;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    connectivity = new Connectivity();
//    subscription =
//        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//          _currentStatus = result.toString();
//          print('discover $_currentStatus');
//          if (result == ConnectivityResult.wifi ||
//              result == ConnectivityResult.mobile) {
//            setState(() {
//            });
//          }
//        });
//  }
//
//  @override
//  void dispose() {
//    subscription.cancel();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Discover(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/category'),
        child: Icon(Icons.category,color: Colors.white,),
        backgroundColor: Colors.grey,
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black87,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 65.0,
          color: Colors.black45,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 60.0,
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 12.0,
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.white70,
                      size: 30.0,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 45.0,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 35.0,
                  ),
                  Text(
                    "Category",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                width: 45.0,
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/bookmark'),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 12.0,
                    ),
                    Icon(
                      Icons.bookmark,
                      color: Colors.white70,
                      size: 30.0,
                    ),
                    Text(
                      'Bookmarks',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
