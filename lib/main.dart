import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/detailScreen.dart';
import 'package:news/login.dart';
import 'package:news/profile/selectProPic.dart';
import 'package:news/signup.dart';
import 'package:news/ui/bookmark.dart';
import 'package:news/ui/category.dart';
import 'package:news/ui/homepage.dart';
import 'package:news/ui/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
          routes: <String ,WidgetBuilder>{
            '/category': (BuildContext context) => Category(),
            '/search': (BuildContext context) => Search(),
            '/bookmark': (BuildContext context) => Bookmark(),
            '/detailscreen': (BuildContext context) => DetailScreen(),
            '/homepage': (BuildContext context) => HomePage(),
            '/signup': (BuildContext context) => SignUp(),
            '/selectpic': (BuildContext context) => SelectprofilepicPage()
          },
    );
  }
}
