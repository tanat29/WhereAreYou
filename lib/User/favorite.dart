import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:noppon/Business/business_add.dart';
import 'package:noppon/Business/business_detail.dart';
import 'package:noppon/Model/place.dart';
import 'package:noppon/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Favorite extends StatefulWidget {
  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  var user_id,
      place_id,
      business_name,
      photo,
      price,
      address,
      rating,
      day,
      time;

  List<Place> place_data = [];
  var email, password, username, tel, type;

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
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
    setState(() {
      //place_id = "";
      user_id = prefs.getString('user_id');
      email = prefs.getString('email');
      password = prefs.getString('password');
      photo = prefs.getString('photo');
      username = prefs.getString('username');
      tel = prefs.getString('tel');
      type = prefs.getString('type');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('รายการโปรดของฉัน')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('like')
            .where("user_id", isEqualTo: user_id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                List<DocumentSnapshot> produdcts = snapshot.data!.docs;
                DocumentSnapshot doc = snapshot.data!.docs[index];
                //var data = getPlace(doc["place_id"], index);

                return PlaceList(doc: doc);
              },
            );
        },
      ),
    );
  }

  void LogoutMethod(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Image.asset(
              'assets/logo.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            Text('  แจ้งเตือน')
          ]),
          content: Text("คุณต้องการออกจากระบบ ใช่หรือไม่?"),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                "ไม่ใช่",
                style: new TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                "ใช่",
                style: new TextStyle(color: Colors.blue),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class PlaceList extends StatelessWidget {
  var doc;
  PlaceList({this.doc});

  Widget build(BuildContext context) {
    print(doc["place_id"]);
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('place')
            .where('place_id', isEqualTo: doc["place_id"])
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 200.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else {
            return Column(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Business_Detail(
                                    place_id: doc["place_id"],
                                    address: doc["address"],
                                    business_name: doc["business_name"],
                                    business_name1: doc["business_name1"],
                                    business_name2: doc["business_name2"],
                                    business_name3: doc["business_name3"],
                                    business_name_english:
                                        doc["business_name_english"],
                                    day: doc["day"],
                                    detail: doc["detail"],
                                    email: doc["email"],
                                    facebook: doc["facebook"],
                                    instagram: doc["instagram"],
                                    line: doc["line"],
                                    latitude: doc["latitude"],
                                    longitude: doc["longitude"],
                                    map: doc["map"],
                                    photo1: doc["photo1"],
                                    photo2: doc["photo2"],
                                    photo3: doc["photo3"],
                                    photo4: doc["photo4"],
                                    photo5: doc["photo5"],
                                    photo6: doc["photo6"],
                                    photo7: doc["photo7"],
                                    photo8: doc["photo8"],
                                    photo9: doc["photo9"],
                                    photo10: doc["photo10"],
                                    price: doc["price"],
                                    rating: doc["rating"],
                                    tel: doc["tel"],
                                    time: doc["time"],
                                    type: doc["type"],
                                    user_id: doc["user_id"],
                                    website: doc["website"],
                                  )),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  document['photo1'],
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: 120.0,
                                      child: Text(
                                        document["business_name"],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            document["price"] + " บาท",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          // Text(
                                          //   'per pax',
                                          //   style: TextStyle(
                                          //     color: Colors.grey,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    document["address"],
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                    "⭐ : " +
                                        document["rating"].toStringAsFixed(1) +
                                        "/5.0",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 16.0)),
                                SizedBox(height: 10.0),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        document["day"],
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Container(
                                      padding: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        document["time"],
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    document["open"] == "true"
                                        ? Container(
                                            padding: EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "ร้านเปิด",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "ร้านปิด",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
        });
  }
}
