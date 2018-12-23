import 'package:flutter/material.dart';
import 'package:news/ui/bookmark.dart';
import 'package:share/share.dart';

class DetailScreen extends StatefulWidget {
  final String title, description, image, author, content;

  DetailScreen(
      {this.title, this.image, this.description, this.author, this.content});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onTap: () { print('Damn You');},
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onTap: (){
                          Share.share('${widget.image}' +
                              '\n${widget.title}' +
                              '\n${widget.description}');
                        }
                      ),
                    ],
                  ),
                ),
                InkWell(
//                  onTap: () => Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => Bookmark(
//                            title: widget.title,
//                            description: widget.description,
//                            image: widget.image,
//                            author: widget.author,
//                          ))),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.blue),
                        child: Icon(
                          Icons.bookmark,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
            child: Row(
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
                )
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
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Text(
              widget.content == null
                  ? 'Sorry this document has no content'
                  : widget.content,
              //overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
