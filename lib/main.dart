import 'package:flutter/material.dart';
import 'package:news/detailScreen.dart';
import 'package:news/ui/bookmark.dart';
import 'package:news/ui/category.dart';
import 'package:news/ui/homepage.dart';
import 'package:news/ui/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
          routes: <String ,WidgetBuilder>{
            '/category': (BuildContext context) => Category(),
            '/search': (BuildContext context) => Search(),
            '/bookmark': (BuildContext context) => Bookmark(),
            '/detailscreen': (BuildContext context) => DetailScreen(),
          },
          theme: ThemeData(
        primarySwatch: Colors.teal
    ),
    );
  }
}
