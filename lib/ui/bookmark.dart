import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/detailScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news/loader.dart';

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark>
    with AutomaticKeepAliveClientMixin {
  Future _data;
  QuerySnapshot qn;

  DetailScreen detailScreen = DetailScreen();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _data = _getBookmarks();
    });
  }

  Future _getBookmarks() async {
    var firestore = Firestore.instance;
    qn = await firestore.collection("myData").getDocuments();
    //print(qn.documents);
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookmarks",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white10,
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Text(
                    "No Bookmarks",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              } else if (snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.active) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 125.0,
                        child: InkWell(
                          onLongPress: () {
                            deleteData(qn.documents[index].documentID);
                            final snackBar = SnackBar(
                              content: Text('Bookmark removed!'),
                              duration: Duration(seconds: 3),
                            );
                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                            Scaffold.of(context).showSnackBar(snackBar);
                            //Navigator.pop(context);
                          },
                          onTap: () =>
                              launchUrl(snapshot.data[index].data['url']),
                          child: Card(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                child: Image.network(
                                  snapshot.data[index].data['image'],
                                  fit: BoxFit.fitHeight,
                                ),
                                height: 150.0,
                                width: 100.0,
                              ),
                              Container(
                                width: 260.0,
                                height: 250.0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index].data['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      overflow: TextOverflow.clip,
                                    ),
                                    Text(
                                      snapshot.data[index].data['url'],
                                      style: TextStyle(color: Colors.blue),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ColorLoader4(
                        dotOneColor: Colors.pink,
                        dotTwoColor: Colors.amber,
                        dotThreeColor: Colors.deepOrange,
                        dotType: DotType.diamond,
                        duration: Duration(seconds: 2),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Loading, please wait...",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  deleteData(docId) {
    Firestore.instance
        .collection('myData')
        .document(docId)
        .delete()
        .catchError((e) => print(e));
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('Couldn\'t launch ${url}');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
