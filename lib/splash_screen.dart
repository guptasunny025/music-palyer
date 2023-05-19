import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/category_choose_screen.dart';
import 'package:music_player/music_player.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLogged;
  SplashScreen({this.isLogged});
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // String _versionName = 'Sunny';
  // final splashDelay = 4;

  @override
  void initState() {
    super.initState();
    //   _loadWidget();
  }

  // _loadWidget() async {
  //   var _duration = Duration(seconds: splashDelay);
  //   return Timer(_duration, navigationPage);
  // }

  // void navigationPage() {
  //   Navigator.pushReplacement(context,
  //       MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: deviceSize.height / 4 / 3,
                  left: deviceSize.width / 4 / 4,
                  right: deviceSize.width / 4 / 4),
              child: Text(
                'Ammeet Vennu',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 30),
              ),
            ),
            SizedBox(
              height: deviceSize.height / 4 / 4 / 2,
            ),
            Container(
              width: deviceSize.width,
              height: deviceSize.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              height: deviceSize.height / 4 / 4,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                child: Container(
                  width: deviceSize.width / 4 / 2,
                  height: deviceSize.width / 4 / 2,
                  child: Image.asset(
                    'assets/facebook.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                onTap: () {},
              )
            ]),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                child: Card(
                  color: Color(0xFFFCA6A5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  margin: EdgeInsets.only(
                      right: deviceSize.width / 4 / 4,
                      bottom: deviceSize.width / 4 / 4),
                  child: Container(
                    width: deviceSize.width / 4 * .8,
                    height: deviceSize.width / 4 / 3,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Skip..',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              widget.isLogged == true
                                  ? CategoryChooseScreen()
                                  : LoginScreen()));
                },
              ),
            ))
          ],
        )
            //     Center(
            //   child: Container(
            //     width: deviceSize.width * .6,
            //     height: deviceSize.height / 3,
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage('assets/background.jpg'), fit: BoxFit.fill),
            //     ),
            //   ),
            // )
            ));
  }
}
