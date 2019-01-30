import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:news/categoryScreens/businessScreen.dart';
import 'package:news/categoryScreens/entertainScreen.dart';
import 'package:news/categoryScreens/healthScreen.dart';
import 'package:news/categoryScreens/scienceScreen.dart';
import 'package:news/categoryScreens/sportsScreen.dart';
import 'package:news/categoryScreens/techScreen.dart';
import 'package:news/ui/bookmark.dart';
import 'package:news/ui/search.dart';

class Category extends StatefulWidget {
  final  String title;
  final MaterialPageRoute pageRoute;

  Category({this.title,this.pageRoute});

  void skipPage(BuildContext context) {
    Navigator.pushReplacement(context, pageRoute);
  }

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin {

  Widget _buildCard(String name, int cardIndex, String image, Icon icon) {
    //final Image images = Image.network(image);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 7.0,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black45,
            ),
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(
                height: 5.0,
              ),
              Text(
                name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ],
      ),
    );
  }

  //MaterialPageRoute pageRoute;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Category())),
        child: Icon(
          Icons.category,
          color: Colors.white,
        ),
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
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search())),
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
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Bookmark())),
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
      body: Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                SizedBox(
                  height: 35.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "Category",
                        style: TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Align(
                      child: IconButton(
                          icon: Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          //onPressed: () => Navigator.pus(context, MaterialPageRoute(builder: (context)=> HomePage()),)
                        ),
                      alignment: Alignment.centerRight,
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ])),
              tiles()
            ],
          ),
        ),
      ),
    );
  }

  Widget tiles() {
    return SliverGrid.count(
      crossAxisCount: 2,
      children: <Widget>[
        InkWell(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TechScreen())),
            child: _buildCard(
                'Technology',
                1,
                "https://images.pexels.com/photos/908284/pexels-photo-908284.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                Icon(
                  Icons.tablet_mac,
                  color: Colors.white,
                ))),
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ArticleScreen())),
          child: _buildCard(
              'Business',
              2,
              'https://images.pexels.com/photos/886465/pexels-photo-886465.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
              Icon(Icons.business, color: Colors.white)),
        ),
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EntertainScreen())),
          child: _buildCard(
              'Entertainment',
              3,
              'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
              Icon(Icons.music_video, color: Colors.white)),
        ),
        InkWell(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HealthScreen())),
          child: _buildCard(
              'Health',
              4,
              'https://images.pexels.com/photos/1282308/pexels-photo-1282308.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
              Icon(Icons.healing, color: Colors.white)),
        ),
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScienceScreen())),
          child: _buildCard(
              'Science',
              5,
              'https://images.pexels.com/photos/256262/pexels-photo-256262.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
              Icon(Icons.ac_unit, color: Colors.white)),
        ),
        InkWell(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SportsScreen())),
          child: _buildCard(
              'Sports',
              6,
              'https://images.pexels.com/photos/248547/pexels-photo-248547.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
              Icon(Icons.rowing, color: Colors.white)),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
