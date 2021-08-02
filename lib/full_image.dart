import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class FullImage extends StatefulWidget {
  var photo;
  FullImage({
    this.photo,
  });

  @override
  _FullImage createState() => _FullImage();
}

class _FullImage extends State<FullImage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: Colors.black,
          child: Center(
            child: Image.network(widget.photo, width: double.maxFinite),
          ),
        ),
        Positioned(
          top: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context, false);
            },
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    ));
  }
}
