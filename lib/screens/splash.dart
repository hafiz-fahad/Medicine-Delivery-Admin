//import 'package:flutter/material.dart';
//import 'package:splashscreen/splashscreen.dart';
//import 'authentication.dart';
//import 'home.dart';
//
//class Splash extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new SplashScreen(
//      seconds: 6,
//      navigateAfterSeconds: new HomePage(),
////      title: new Text('Meds @ Home',
////        style: new TextStyle(
////            fontWeight: FontWeight.bold,
////            fontSize: 20.0,
//////            color: Colors.white
////        ),
////      ),
//      image: new Image.asset('images/logo.png',alignment: Alignment.center,),
////      gradientBackground: new LinearGradient(colors: [Colors.black12, Colors.grey], begin: Alignment.topLeft, end: Alignment.bottomRight),
//      backgroundColor: Colors.white,
//      loadingText: new Text('We care about you...'),
//      styleTextUnderTheLoader: new TextStyle(color: Colors.blue),
//      photoSize: 100.0,
////      onClick: ()=>print("Flutter Egypt"),
//      loaderColor: Colors.white,
//    );  }
//}

import 'dart:async';

//import 'package:Aeologic/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:meds_at_home/screens/home.dart';
import 'admin.dart';
class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 6);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) => new
        Admin()));
//    Navigator.of(context).pushReplacementNamed(HomePage());
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 5));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: new Text('We care about you...')

//                  new Image.asset(
//                    'images/logo.png',
//                    height: 25.0,
//                    fit: BoxFit.scaleDown,
//                  )
              )
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'icons/adminSplash.png',
                width: animation.value * 250,
                height: animation.value * 500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}