import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:news/detailScreen.dart';
import 'package:news/loader.dart';
import 'package:news/model/businessModel.dart';
import 'package:http/http.dart' as http;
import 'package:news/discoverScreens/recentNews.dart';

class TopNews extends StatefulWidget {
  final Source source;

  TopNews({Key key, this.source}) : super(key: key);

  @override
  _TopNewsState createState() => _TopNewsState();
}

class _TopNewsState extends State<TopNews> with AutomaticKeepAliveClientMixin {
  String API_KEY = '0ca85f22bce44565ba4fee8d2224adb5';
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  Future<List<Articles>> fetchArticleBySource() async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=${API_KEY}');

    if (response.statusCode == 200) {
      List articles = json.decode(response.body)['articles'];
      setState(() {});
      return articles.map((article) => new Articles.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load article list');
    }
  }

  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future _data;

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
    setState(() {
      _data = list_articles;
    });
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
    double height = MediaQuery.of(context).size.height;
    super.build(context);
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
            height: height / 2.5,
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
                          description: article.description,
                          url: article.url,
                          publishedAt: article.publishedAt,
                        ))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        width: 280.0,
                        height: 330.0,
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            //clipper: clipper,
                            borderRadius: BorderRadius.circular(10.0),
                            child: article.urlToImage != null
                                ? Image.network(
                              article.urlToImage,
                              fit: BoxFit.cover,
                            )
                                : Image.asset('images/logo.jpg'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: SizedBox(
                        width: 260.0,
                        height: 60.0,
                        child: Text(
                          '${article.title}',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ))
                  .toList(),
            ),
          );
        } else {
          return Center(child: Column(
            children: <Widget>[
              ColorLoader4(
                dotOneColor: Colors.pink,
                dotTwoColor: Colors.amber,
                dotThreeColor: Colors.deepOrange,
                dotType: DotType.diamond,
                duration: Duration(milliseconds: 1200),
              ),
              Text('Fetching news please wait...',style: TextStyle(
                  color: Colors.white
              ),),
            ],
          ));
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
