import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/services/usermanagement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var profilePicUrl =
      'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg';

  var name = 'Tom';

  bool isLoading = false;

  File selectedImage;

  UserManagement userManagement = new UserManagement();

  String newName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        profilePicUrl = user.photoUrl;
        name = user.displayName;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future selectPhoto() async {
    setState(() {
      isLoading = true;
    });
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = tempImage;
      uploadImage();
    });
  }

  Future uploadImage() async {
    var randomno = Random(25);
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilepics/${randomno.nextInt(5000).toString()}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

    task.future.then((value) {
      setState(() {
        userManagement
            .updateProfilePic(value.downloadUrl.toString())
            .then((val) {
          setState(() {
            profilePicUrl = value.downloadUrl.toString();
            isLoading = false;
          });
        });
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> editName(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Nick Name', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 100.0,
              width: 100.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'New Name',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold)),
                    onChanged: (value) {
                      newName = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = true;
                  });
                  userManagement.updateNickName(newName).then((onValue) {
                    setState(() {
                      isLoading = false;
                      name = newName;
                    });
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  getLoader() {
    return isLoading
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                profilePicUrl,
              ),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.white,
                  child: ClipPath(
                      clipper: MyClipper(),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 145.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  name,
                                  style: TextStyle(fontSize: 25.0),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 7.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "susan@gmail.com",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    //SizedBox(width: 50.0,),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Icon(Icons.email),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: StreamBuilder(
                                  //stream: bloc.submitCheck,
                                  builder: (context, snapshot) {
                                    return InkWell(
//                                  onTap: snapshot.hasData
//                                      ? () => changeThePage(context)
//                                      : null,
                                      child: Container(
                                        height: 50.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            gradient: LinearGradient(colors: [
                                              const Color(0xFF5c0f2a),
                                              const Color(0xFFff8a9b),
                                            ])),
                                        child: Center(
                                          child: Text(
                                            'Logout',
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 345.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Hero(
                    tag: 'img',
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage(
                        profilePicUrl,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height / 3.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
