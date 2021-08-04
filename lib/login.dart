// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noppon/Entrepreneur/launcher.dart';
import 'package:noppon/User/launcher_user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ประกาศตัวแปร
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _validate = false;

  @override
  void initState() {
    emailController.text = "";
    passwordController.text = "";
    super.initState();
  }

  // เข้าสู่ฟังก์ชัน Login
  void validateAndSubmit() async {
    FocusScope.of(context).unfocus(); // ปิดคีบอร์ด
    var email = emailController.text.toString().trim();
    var password = passwordController.text.toString().trim();

    // เช็คอีเมลล์ว่าง
    if (email.isEmpty) {
      Toast.show("กรุณาใส่อีเมลล์ก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    // เช็ครหัสว่าง
    if (password.isEmpty) {
      Toast.show("กรุณาใส่รหัสผ่านก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    // แสดง Progress
    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(
        message: "กรุณารอสักครู่ ...",
        progressWidget: Container(
            margin: EdgeInsets.all(10.0), child: CircularProgressIndicator()));
    pDialog.show();

    // เช็คข้อมูล
    if (await checkLogin(email, password)) {
      // ถ้าไม่ถูก
      pDialog.hide();
      Toast.show("อีเมลล์หรือรหัสไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      // ถ้าถูกต้อง
      FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) async {
          pDialog.hide();
          // รับค่าจาก Firestore
          var User_id = result.data()["user_id"];
          var Email = result.data()["email"];
          var Password = result.data()["password"];
          var Username = result.data()["username"];
          var Photo = result.data()["photo"];
          var Tel = result.data()["tel"];
          var Type = result.data()["type"];
          // เก็บใน SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool("check", true);
          await prefs.setString('user_id', User_id);
          await prefs.setString('email', Email);
          await prefs.setString('password', Password);
          await prefs.setString('photo', Photo);
          await prefs.setString('username', Username);
          await prefs.setString('tel', Tel);
          await prefs.setString('type', Type);

          // ถ้าเป็น ผู้ประกอบการ ให้ไป Launcher ถ้าไม่ใช่ไป Launcher_User
          if (Type == "ผู้ประกอบการ") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Launcher()),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Launcher_User()),
              (Route<dynamic> route) => false,
            );
          }
        });
      }).catchError((e) {
        // ดัก Error
        Toast.show("เกิดข้อผิดพลาด กรุณาลองใหม่", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        pDialog.hide();
      });
    }
  }

  Future<bool> checkLogin(String email, String password) async {
    // เช็คการ Login ว่าถูกต้องหรือไม่
    bool check = false;
    final snapshot = await FirebaseFirestore.instance
        .collection("user")
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (snapshot.docs.length == 0) {
      setState(() {
        // ถ้าไม่ถูกต้อง
        check = true;
      });
    } else {
      setState(() {
        // ถ้าถูกต้อง
        check = false;
      });
    }
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/map.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Center(
                  child: new ListView(
                    padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 70, 0, 10),
                          child: Text('Where are you',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 45.0,
                                  fontWeight: FontWeight.bold))),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50.0, 10, 10),
                        child: new Theme(
                          data: Theme.of(context)
                              .copyWith(splashColor: Colors.transparent),
                          child: TextField(
                            controller: emailController,
                            autofocus: false,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'กรุณาใส่อีเมลล์',
                              errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 10),
                        child: new Theme(
                          data: Theme.of(context)
                              .copyWith(splashColor: Colors.transparent),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            autofocus: false,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'กรุณาใส่รหัสผ่าน',
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(10, 30, 20, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              padding: EdgeInsets.all(8),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: new TextStyle(fontSize: 20.0),
                            ),
                            onPressed: () {
                              // ไปที่ Method validateAndSubmit()
                              validateAndSubmit();
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ยังไม่มีบัญชีใช่หรือไม่',
                              style: new TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w300)),
                          new InkWell(
                              onTap: () {
                                // ไปหน้าสมัครสมาชิก
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()),
                                );
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text("สมัครเลย",
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue)))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
