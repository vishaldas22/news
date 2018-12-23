import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/detailScreen.dart';
import 'package:news/model/businessModel.dart';

class RecentNews extends StatefulWidget {
  final Source source;

  RecentNews({Key key, this.source}) : super(key: key);

  @override
  _RecentNewsState createState() => _RecentNewsState();
}

class _RecentNewsState extends State<RecentNews> {
  String API_KEY = '0ca85f22bce44565ba4fee8d2224adb5';
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  Future<List<Articles>> fetchArticleBySource() async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?sources=google-news&apiKey=${API_KEY}');

    if (response.statusCode == 200) {
      List articles = json.decode(response.body)['articles'];
      setState(() {
      });
      return articles.map((article) => new Articles.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load article list');
    }
  }

  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

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
//    setState(() {});
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<Articles>>(
        future: list_articles,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Please check your internet connection!!',
              style: TextStyle(color: Colors.white),
            );
          } else if (snapshot.hasData) {
            List<Articles> articles = snapshot.data;
            return Container(
              height: size.height / 2.5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Recent News",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "See All",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Container(
                    height: 250.0,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: articles
                          .map((article) => GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                              title: article.title,
                                              content: article.content,
                                              image: article.urlToImage,
                                              author: article.author,
                                            ))),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        //height: 150.0,
                                        width: 150.0,
                                        child: Card(
                                          elevation: 3.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: article.urlToImage != null
                                                ? Image.network(
                                                    article.urlToImage,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.asset(
                                                    'images/logo.jpg',
                                                    fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 4.0),
                                      child: SizedBox(
                                        width: 130.0,
                                        height: 130.0,
                                        child: Text(
                                          "${article.title}",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
