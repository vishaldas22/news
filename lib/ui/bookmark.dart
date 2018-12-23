import 'package:flutter/material.dart';

class Bookmark extends StatefulWidget {
  final String title, description, image, author;

  Bookmark({this.title, this.image, this.description, this.author});

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark>
    with AutomaticKeepAliveClientMixin {
  List<Bookmark> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      list.add(bookmarks());
    });
  }

  Widget bookmarks(){
    return Card(
        child: Row(
          children: <Widget>[
            SizedBox(
              child: Image.network(
                widget.image,
              ),
              height: 100.0,
              width: 100.0,
            ),
            Column(
              children: <Widget>[
                Text(
                  widget.title,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(widget.description,style: TextStyle(color: Colors.grey),overflow: TextOverflow.clip,),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          bookmarks(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
