import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/services/usermanagement.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _name;
  String _email;
  String _password;
  String _phone;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color(0xFF5c0f2a),
            const Color(0xFFff8a9b),
          ])),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 680.0,
                    width: 150.0,
                    child: ClipPath(
                      clipper: MyClipper(),
                      child: Card(
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 15.0, 8.0, 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color(0xFF5c0f2a),
                                    const Color(0xFFff8a9b),
                                  ]),
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 15.0,
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 70.0, left: 15.0),
                              child: Hero(
                                tag: 'logo',
                                child: FlutterLogo(
                                  size: 80.0,
                                  colors: Colors.red,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 50.0, right: 15.0),
                              child: Form(
                                child: Column(
                                  children: <Widget>[
                                    StreamBuilder(builder: (context, snapshot) {
                                      return Theme(
                                        data: ThemeData(
                                            hintColor: Colors.grey,
                                            primaryColor: Colors.pinkAccent,
                                            cursorColor: Colors.pinkAccent),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Name',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            suffixIcon: Icon(Icons.person),
                                          ),
                                          onChanged: (value){
                                            _name = value;
                                          },
                                        ),
                                      );
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: StreamBuilder(
                                          builder: (context, snapshot) {
                                        return Theme(
                                          data: ThemeData(
                                              hintColor: Colors.grey,
                                              primaryColor: Colors.pinkAccent,
                                              cursorColor: Colors.pinkAccent),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Email',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              suffixIcon: Icon(Icons.email),
                                            ),
                                            onChanged: (value){
                                              _email = value;
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: StreamBuilder(
                                          builder: (context, snapshot) {
                                        return Theme(
                                          data: ThemeData(
                                              hintColor: Colors.grey,
                                              primaryColor: Colors.pinkAccent,
                                              cursorColor: Colors.pinkAccent),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Phone',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              suffixIcon: Icon(Icons.phone_android),
                                            ),
                                            onChanged: (value){
                                              _phone = value;
                                            },
                                            keyboardType: TextInputType.number,
                                          ),
                                        );
                                      }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: StreamBuilder(
                                          builder: (context, snapshot) {
                                        return Theme(
                                          data: ThemeData(
                                              hintColor: Colors.grey,
                                              primaryColor: Colors.pinkAccent,
                                              cursorColor: Colors.pinkAccent),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Password',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              suffixIcon: Icon(Icons.lock),
                                            ),
                                            obscureText: true,
                                            onChanged: (value){
                                              _password = value;
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0, top: 85.0, bottom: 15.0,left: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: ()=> Navigator.pop(context),
                                      child: Text("Login ?",style: TextStyle(color: Colors.blue,fontSize: 18.0),)),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                          email: _email, password: _password)
                                          .then((signedInUser) {
                                        var userUpdateInfo = new UserUpdateInfo();
                                        userUpdateInfo.displayName = _name;
                                        userUpdateInfo.photoUrl =
                                        'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg';
                                        FirebaseAuth.instance.updateProfile(userUpdateInfo)
                                            .then((user) {
                                          FirebaseAuth.instance
                                              .currentUser()
                                              .then((user) {
                                            UserManagement()
                                                .storeNewUser(user, context);
                                          }).catchError((e) {
                                            print(e);
                                          });
                                        }).catchError((e) {
                                          print(e);
                                        });
                                      }).catchError((e) {
                                        print(e);
                                      });
                                    },
                                    child: Container(
                                      height: 50.0,
                                      width: 200.0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          gradient: LinearGradient(colors: [
                                            const Color(0xFF5c0f2a),
                                            const Color(0xFFff8a9b),
                                          ])),
                                      child: Center(
                                        child: Text(
                                          'Signup',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0,top: 24.0,),
          child: Align(
            alignment: Alignment.topRight,
            child: ClipPath(
              clipper: MyClippers(),
              child: Container(
                height: 70.0,
                width: 140.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right:2.0,bottom: 14.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xFFe59dff),
                          const Color(0xFF4a0521),
                        ]),
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 15.0,
                        child: Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyClippers extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(
        size.width, 0.0,
    );
    path.lineTo(
      size.width,
      size.height,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}


class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(
      0.0,
      size.height,
    );
    path.lineTo(
      size.width,
      size.height,
    );
    path.lineTo(
      size.width,
      size.height / 3.5,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
