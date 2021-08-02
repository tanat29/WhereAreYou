import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ZZ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var place_id, user_id;
  bool isLiked = false;
  double rating = 5;
  List<int> rating_count = [];
  List<double> array_comment = [];

  DateTime now = new DateTime.now();

  TextEditingController commentController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    place_id = "xG07ykkAfCQZ744993GP";
    user_id = "UNzeBoWb0oYzCsa5SFBy";

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    // double total = 0, count = 0;
    // FirebaseFirestore.instance
    //     .collection('comment')
    //     .where('place_id', isEqualTo: place_id)
    //     .get()
    //     .then((querySnapshot) {
    //   querySnapshot.docs.forEach((result) async {
    //     //print(result.data()["email"]);

    //     // rating_count.add(result.data()['rating']);
    //     // getAverageRating(rating_count);

    //     total = total + result.data()['rating'];
    //     count++;

    //     var average = total / count;
    //     print(average.toStringAsFixed(1));
    //   });
    // });
  }

  LikeMethod(String like) {
    if (like == "like") {
      Toast.show("UnLike", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      // FirebaseFirestore.instance
      //     .collection('like')
      //     .where('place_id', isEqualTo: place_id)
      //     .where('user_id', isEqualTo: user_id)
      //     .limit(1)
      //     .get()
      //     .then((querySnapshot) {
      //   querySnapshot.docs.forEach((result) async {
      //     var Like_id = result.data()["like_id"];
      //     FirebaseFirestore.instance.collection("like").doc(Like_id).delete();
      //   });
      // });
    } else {
      Toast.show("Like", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      // FirebaseFirestore.instance.collection('like').add({
      //   'place_id': place_id,
      //   'user_id': user_id,
      // }).then((value) => FirebaseFirestore.instance
      //     .collection('like')
      //     .doc(value.id)
      //     .update({'like_id': value.id}));
    }
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat.MMMd('th');

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: Center(
          child: Row(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(10, 30, 20, 10),
            child: Text(
              '${formatter.format(now) + ' ${now.year + 543}'}',
              style: new TextStyle(fontSize: 20.0),
            ),
          ),
          getTypeArray('1Ummet9VVq26WsVIPiQl'),
        ],
      )),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () async {
          final snapshot =
              await FirebaseFirestore.instance.collection("comment").get();
          if (snapshot.docs.length == 0) {
            print("Null");
          } else {
            FirebaseFirestore.instance
                .collection('comment')
                .orderBy('array', descending: true)
                .limit(1)
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((result) async {
                var array_comment = result.data()['array'] + 1;
                print(array_comment);
              });
            });
          }
        },
      ),
    );
  }

  void getAverageRating(List<int> rating_count) {
    double total = 0, count = 0;
    for (int i = 0; i < rating_count.length; i++) {
      total = total + rating_count[i];
      count++;
    }

    var average = total / count;
    print(average.toStringAsFixed(1));
  }

  Text getTypeArray(String s) {
    List<String> names = [];
    FirebaseFirestore.instance
        .collection("place")
        .where("business_name", isEqualTo: "ร้าน ABC")
        .get()
        .then((value) {
      value.docs.forEach((result) async {
        //print(result.data()["email"]);
        names = List.from(result.data()['type2']);
        print(names[1]);
      });
      //print(value.data()!['type2']);
      // first add the data to the Offset object
    });

    return Text("asd");
  }
}
