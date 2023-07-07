import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/file_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _width = 200;
  double _height = 200;

  // @override
  void updateState() {
    setState(() {
      _width = 400;
      _height = 400;
    });
  }

  @override
  void initState() {
    super.initState();
    FileUtilsUser.readFromFile().then((content) {
      updateState();
      if (content == "") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MasukScreen())));
      } else {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          id: content,
                        ))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _width,
                  height: _height,
                  curve: Curves.bounceIn,
                  child: Image.asset(
                    "assets/images/sp_logo_splash.png",
                    height: 300.0,
                    width: 300.0,
                  ),
                ),
              ],
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mYellowPu),
            ),
          ],
        ),
      ),
    );
  }
}
