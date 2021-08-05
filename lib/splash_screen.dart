import 'package:flutter/material.dart';
import 'package:noppon/Entrepreneur/launcher.dart';
import 'package:noppon/User/launcher_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _TimerButton createState() => _TimerButton();
}

class _TimerButton extends State<SplashScreen> {
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 2;
  int currentSeconds = 0;

  startTimeout() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      try {
        setState(() async {
          currentSeconds = timer.tick;

          if (timer.tick >= timerMaxSeconds) {
            //timer.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        });
      } catch (e) {}
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var Check = prefs.getBool('check');
    var UserType = prefs.getString('type');

    if (Check == true) {
      // ถ้า Login ไว้แล้ว
      if (UserType == 'ผู้ประกอบการ') {
        // ผู้ประกอบการ จะไปหน้า Launcher
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Launcher()),
          (Route<dynamic> route) => false,
        );
      } else {
        // ผู้ใช้ทั่วไป จะไปหน้า Launcher_User
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Launcher_User()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      // ไปฟังก์ชันนับเวลา
      startTimeout();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 200.0,
              height: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
