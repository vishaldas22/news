import 'package:flutter/material.dart';
import 'package:news/bloc.dart';
import 'package:news/ui/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  final bloc = Bloc();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _email, _password;

  changeThePage(BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((FirebaseUser user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
    animation.addListener(() => this.setState(() {}));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              const Color(0xFF5c0f2a),
              const Color(0xFFff8a9b),
            ])),
            child: ListView(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      height: 680.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 2.0,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50.0, left: 15.0),
                                  child: Hero(
                                    tag: 'logo',
                                    child: FlutterLogo(
                                      size: animation.value * 100,
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
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25.0),
                                          child: Theme(
                                            data: ThemeData(
                                                hintColor: Colors.grey,
                                                primaryColor: Colors.pinkAccent,
                                                cursorColor: Colors.pinkAccent),
                                            child: TextField(
                                              onChanged: bloc.emailChanged,
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                suffixIcon: Icon(Icons.email),
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                            ),
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: Theme(
                                          data: ThemeData(
                                              hintColor: Colors.grey,
                                              primaryColor: Colors.pinkAccent,
                                              cursorColor: Colors.pinkAccent),
                                          child: TextField(
                                            onChanged: bloc.passwordChanged,
                                            decoration: InputDecoration(
                                              hintText: 'Password',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              suffixIcon: Icon(Icons.lock),
                                            ),
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40.0, left: 30.0, right: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => Navigator.pushNamed(
                                            context, '/signup'),
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => changeThePage(context),
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
                                              'Login',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, bottom: 20.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
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
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ClipPath(
                clipper: MyClippers(),
                child: Container(
                  height: 70.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, top: 14.0),
                    child: Align(
                      alignment: Alignment.topLeft,
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
                            Icons.arrow_upward,
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
//          InkWell(
//            onTap: () {
//              googleSignIn.signIn().then((result) {
//                result.authentication.then((googleKey) {
//                  FirebaseAuth.instance
//                      .signInWithGoogle(
//                          idToken: googleKey.idToken,
//                          accessToken: googleKey.accessToken)
//                      .then((signedInUser) {
//                    print('Signed in as ${signedInUser.displayName}');
//                    Navigator.of(context).pushReplacement(MaterialPageRoute(
//                        builder: (BuildContext context) => HomePage()));
//                  }).catchError((e) {
//                    print(e);
//                  });
//                }).catchError((e) {
//                  print(e);
//                });
//              }).catchError((e) {
//                print(e);
//              });
//            },
//            child: Padding(
//              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 25.0),
//              child: Align(
//                alignment: Alignment.bottomCenter,
//                child: CircleAvatar(
//                  radius: 25.0,
//                  child: Image.asset('images/google.jpg'),
//                  backgroundColor: Colors.transparent,
//                ),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}

class MyClippers extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
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
      size.height / 1.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
