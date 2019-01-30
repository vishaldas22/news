import 'package:flutter/material.dart';
import 'package:news/ui/bookmark.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  final String title, description, image, author, content, url, publishedAt;

  DetailScreen(
      {this.title,
      this.image,
      this.description,
      this.author,
      this.content,
      this.url,
      this.publishedAt});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DocumentReference documentReference =
      Firestore.instance.collection('myData').document();

  QuerySnapshot querySnapshot;

   alreadyExists() async {
    try {
      final QuerySnapshot result = await Firestore.instance
          .collection('myData')
          .where('title', isEqualTo: widget.title)
          .limit(1)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 1) {
        final snackBar = SnackBar(
          content: Text('Bookmark already exists!'),
          duration: Duration(seconds: 2),
        );
        // Find the Scaffold in the Widget tree and use it to show a SnackBar!
        _scaffoldkey.currentState
            .showSnackBar(snackBar);
      }
      if (documents.length == 0) {
          addData();
      }
    } catch (e) {
      print("Error");
    }
  }

  void addData(){
    Firestore.instance.document('myData/${widget.title}').setData({
      'author': widget.author,
      'content': widget.content,
      'image': widget.image,
      'publishedAt': widget.publishedAt,
      'title': widget.title,
      'url': widget.url,
    });
    final snackBar = SnackBar(
      content: Text('Bookmark added!'),
      duration: Duration(seconds: 2),
    );
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    _scaffoldkey.currentState
        .showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      body: ListView(
        children: <Widget>[
          Container(
            height: size.height / 2.6,
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                SizedBox(
                    height: size.height / 2.8,
                    width: size.width,
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.fill,
                    )),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.bookmark,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                alreadyExists();

                              }),
                          GestureDetector(
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Share.share('${widget.url}');
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
            child: Text(
              widget.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black),
              overflow: TextOverflow.clip,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0, left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 15.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      widget.author == null ? 'No Author' : widget.author,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      color: Colors.grey,
                      size: 15.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      widget.publishedAt == null
                          ? ''
                          : widget.publishedAt.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.content == null ? widget.title : widget.content,
                    overflow: TextOverflow.clip,
                  ),
                  GestureDetector(
                    child: Text('Read more',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        )),
                    onTap: () {
                      launchUrl(widget.url);
                    },
                  )
                ],
              )),
        ],
      ),
    );
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('Couldn\'t launch ${url}');
    }
  }
}
