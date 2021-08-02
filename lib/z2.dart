import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noppon/Model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class Z2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage2(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  @override
  _MyHomePageState2 createState() => new _MyHomePageState2();
}

class _MyHomePageState2 extends State<MyHomePage2> {
  var photo1 =
      "https://i.pinimg.com/originals/3b/8a/d2/3b8ad2c7b1be2caf24321c852103598a.jpg";
  var photo2 =
      "https://img.freepik.com/free-vector/colorful-palm-silhouettes-background_23-2148541792.jpg?size=626&ext=jpg";
  var photo3 =
      "https://img.freepik.com/free-vector/dark-paper-layers-wallpaper-with-golden-details_23-2148403401.jpg?size=626&ext=jpg";
  var photo4 = "https://wallpaperaccess.com/full/3295984.jpg";
  var photo5 =
      "https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80";
  var photo6 =
      "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80";
  var photo7 =
      "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80";
  var photo8 =
      "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80";
  var photo9 =
      "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80";
  var photo10 =
      "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80";

  TextEditingController latitude_Controller = TextEditingController();
  TextEditingController longitude_Controller = TextEditingController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Carousel with indicator controller demo')),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "ละติจูด",
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: new TextFormField(
                maxLines: 1,
                autofocus: false,
                controller: latitude_Controller,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(hintText: 'กรุณาใส่ละติจูด'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "ลองจิจูด",
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: new TextFormField(
                maxLines: 1,
                autofocus: false,
                controller: longitude_Controller,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(hintText: 'กรุณาใส่ลองจิจูด'),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  // ignore: non_constant_identifier_names
                  var Latitude = latitude_Controller.text;
                  print(double.parse(Latitude));
                },
                child: Text("Save"))
          ],
        ));
  }
}
