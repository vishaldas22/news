import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/discoverScreens/topNews.dart';
import 'package:news/model/businessModel.dart';
import 'package:http/http.dart' as http;
import 'package:news/discoverScreens/recentNews.dart';
import 'package:news/profile/profile.dart';


class Discover extends StatefulWidget {
  final Source source;

  Discover({Key key, this.source}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover>
    with AutomaticKeepAliveClientMixin {
  String API_KEY = '0ca85f22bce44565ba4fee8d2224adb5';
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  Future<List<Articles>> fetchArticleBySource() async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=${API_KEY}');

    if (response.statusCode == 200) {
      List articles = json.decode(response.body)['articles'];
      setState(() {
      });
      return articles.map((article) => new Articles.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load article list');
    }
  }

  Future<List<Articles>> fetchArticlesBySource() async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?sources=google-news&apiKey=${API_KEY}');

    if (response.statusCode == 200) {
      List articles = json.decode(response.body)['articles'];
      setState(() {});
      return articles.map((article) => new Articles.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load article list');
    }
  }

  var list_articles;
  var list_article;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var now = new DateFormat.MMMMEEEEd().format(new DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            list_articles = fetchArticleBySource();
          }
        });

    refreshListArticle();
    //setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<Null> refreshListArticle() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      list_articles = fetchArticleBySource();
      list_article = fetchArticlesBySource();
    });
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    super.build(context);
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          top: 15.0,
          right: 15.0,
        ),
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshListArticle,
          child: ListView(
            children: <Widget>[
              topArea(),
              SizedBox(
                height: 10.0,
              ),
              //slideCard(height / 2.3),
              TopNews(),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              RecentNews(),
            ],
          ),
        )
      ),
    );
  }

  Widget topArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "$now",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "TOP NEWS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Profile())),
          child: Hero(
            tag: 'img',
            child: CircleAvatar(
              radius: 25.0,
              //backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                "https://images.pexels.com/photos/1138409/pexels-photo-1138409.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
              ),
            ),
          ),
        ),
      ],
    );
  }

//  Widget slideCard(double height) {
//    return FutureBuilder<List<Articles>>(
//      future: list_articles,
//      builder: (context, snapshot) {
//        if (snapshot.hasError) {
//          return Text(
//            'Please check your internet connection!!',
//            style: TextStyle(color: Colors.white),
//          );
//        } else if (snapshot.hasData) {
//          List<Articles> articles = snapshot.data;
//          return Container(
//            height: height,
//            child: ListView(
//              shrinkWrap: true,
//              scrollDirection: Axis.horizontal,
//              children: articles
//                  .map((article) => GestureDetector(
//                onTap: () => Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => DetailScreen(
//                          title: article.title,
//                          content: article.content,
//                          image: article.urlToImage,
//                          author: article.author,
//                        ))),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Expanded(
//                      child: SizedBox(
//                        width: 280.0,
//                        height: 330.0,
//                        child: Card(
//                          elevation: 3.0,
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(10.0),
//                          ),
//                          child: ClipRRect(
//                            //clipper: clipper,
//                            borderRadius: BorderRadius.circular(10.0),
//                            child: article.urlToImage != null
//                                ? Image.network(
//                              article.urlToImage,
//                              fit: BoxFit.cover,
//                            )
//                                : Image.asset('images/logo.jpg'),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10.0,
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(left: 4.0),
//                      child: SizedBox(
//                        width: 260.0,
//                        height: 60.0,
//                        child: Text(
//                          '${article.title}',
//                          overflow: TextOverflow.clip,
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 18.0,
//                              fontWeight: FontWeight.bold),
//                        ),
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10.0,
//                    ),
//                  ],
//                ),
//              ))
//                  .toList(),
//            ),
//          );
//        } else {
//          return Center(child: CircularProgressIndicator());
//        }
//      },
//    );
//  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
