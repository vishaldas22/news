import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news/detailScreen.dart';
import 'package:news/model/businessModel.dart';

import 'package:http/http.dart' as http;


String API_KEY = '0ca85f22bce44565ba4fee8d2224adb5';

Future<List<Articles>> fetchArticleBySource() async {
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?sources=medical-news-today&apiKey=${API_KEY}');

  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    return articles.map((article) => new Articles.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load article list');
  }
}

class HealthScreen extends StatefulWidget {
  final Source source;

  HealthScreen({Key key,  this.source}) : super(key: key);
  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListArticle();
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
    return MaterialApp(
      title: "NEWS",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Health News",style: TextStyle(
            color: Colors.black
          ),),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: RefreshIndicator(
              child: FutureBuilder<List<Articles>>(
                future: list_articles,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<Articles> articles = snapshot.data;
                    return ListView(
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
                        child: Card(
                          elevation: 1.0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 4.0),
                                width: 150.0,
                                height: 100.0,
                                child: article.urlToImage != null
                                    ? Image.network(article.urlToImage,height: 180.0,fit: BoxFit.cover,)
                                    : Image.asset('images/logo.jpg'),
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 8.0,
                                                  bottom: 10.0),
                                              child: Text(
                                                "${article.title}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8.0),
                                        child: Text('${article.description}', style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8.0,top: 10.0,bottom: 10.0),
                                        child: Text('PublishedAt: ${article.publishedAt}', style: TextStyle(
                                            color: Colors.black12,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ))
                          .toList(),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              key: refreshKey,
              onRefresh: refreshListArticle),
        ),
      ),
    );
  }

//  launchUrl(String url) async{
//    if(await canLaunch(url)){
//      await launch(url);
//    }else{
//      throw('Couldn\'t launch ${url}');
//    }
//  }
}
