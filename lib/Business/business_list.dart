import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:noppon/Business/business_add.dart';
import 'dart:ui';
import 'dart:async';
import 'package:noppon/Business/business_add.dart';
import 'package:noppon/Business/business_detail.dart';
import 'package:noppon/Business/business_edit.dart';
import 'package:toast/toast.dart';

class Business_List extends StatefulWidget {
  var type;
  Business_List({this.type});

  @override
  _Business_List createState() => _Business_List();
}

class _Business_List extends State<Business_List> {
  Widget appBarTitle = Text(
    "สถานที่ทั้งหมด",
    style: new TextStyle(color: Colors.white),
  );

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  //late List<String> _list;
  late bool _IsSearching;
  String _searchText = "";

  _Business_List() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
          print(_searchText);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    //init();
  }

  getFirebase() {
    if (_searchText == "") {
      return FirebaseFirestore.instance
          .collection('place')
          .orderBy("array", descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('place')
          .orderBy('business_name')
          .startAt([_searchText]).endAt([_searchText + '\uf8ff']).snapshots();
    }
  }

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appBarTitle, actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = new TextField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "กรุณาใส่คำค้นหา...",
                      hintStyle: new TextStyle(color: Colors.white)),
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ]),
      //title: Text(widget.type)
      body: StreamBuilder<QuerySnapshot>(
        stream: getFirebase(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Visibility(
                    child: CircularProgressIndicator(), visible: true));
          } else
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return doc['type'] == widget.type
                    ? Stack(
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
                                          rating:
                                              doc["rating"].toStringAsFixed(1),
                                          tel: doc["tel"],
                                          time: doc["time"],
                                          type: doc["type"],
                                          user_id: doc["user_id"],
                                          website: doc["website"],
                                        )),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Row(children: [
                                        Image.asset(
                                          'assets/logo.png',
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.contain,
                                        ),
                                        Text('  กรุณาเลือกคำสั่ง')
                                      ]),
                                      children: [
                                        SimpleDialogOption(
                                          onPressed: () {
                                            doc['open'] == 'true'
                                                ? FirebaseFirestore.instance
                                                    .collection('place')
                                                    .doc(doc["place_id"])
                                                    .update({
                                                    'open': 'false'
                                                  }).then((value) {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');

                                                    Toast.show("ปิดร้านสำเร็จ",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                  })
                                                : FirebaseFirestore.instance
                                                    .collection('place')
                                                    .doc(doc["place_id"])
                                                    .update({
                                                    'open': 'true'
                                                  }).then((value) =>
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog'));
                                            Toast.show(
                                                "เปิดร้านสำเร็จ", context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          },
                                          child: const Text('เปิด/ปิดร้าน'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BusinessEdit(
                                                        place_id:
                                                            doc["place_id"],
                                                        address: doc["address"],
                                                        business_name: doc[
                                                            "business_name"],
                                                        business_name1: doc[
                                                            "business_name1"],
                                                        business_name2: doc[
                                                            "business_name2"],
                                                        business_name3: doc[
                                                            "business_name3"],
                                                        business_name_english: doc[
                                                            "business_name_english"],
                                                        day: doc["day"],
                                                        detail: doc["detail"],
                                                        email: doc["email"],
                                                        facebook:
                                                            doc["facebook"],
                                                        instagram:
                                                            doc["instagram"],
                                                        line: doc["line"],
                                                        latitude:
                                                            doc["latitude"],
                                                        longitude:
                                                            doc["longitude"],
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
                                          child: const Text('แก้ไขสถานที่'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('place')
                                                .doc(doc["place_id"])
                                                .delete()
                                                .then((value) {
                                              FirebaseFirestore.instance
                                                  .collection('comment')
                                                  .doc(doc["place_id"])
                                                  .delete();

                                              FirebaseFirestore.instance
                                                  .collection('like')
                                                  .doc(doc["place_id"])
                                                  .delete();
                                            });

                                            List<String> photo_array = [
                                              doc["photo1"],
                                              doc["photo2"],
                                              doc["photo3"],
                                              doc["photo4"],
                                              doc["photo5"],
                                              doc["photo6"],
                                              doc["photo7"],
                                              doc["photo8"],
                                              doc["photo9"],
                                              doc["photo10"]
                                            ];

                                            for (int i = 0;
                                                i < photo_array.length;
                                                i++) {
                                              if (photo_array[i].isNotEmpty) {
                                                FirebaseStorage.instance
                                                    .refFromURL(photo_array[i])
                                                    .delete();
                                              }
                                            }

                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop('dialog');
                                            Toast.show(
                                                "ลบสถานที่สำเร็จ", context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          },
                                          child: const Text('ลบสถานที่'),
                                        )
                                      ],
                                    );
                                  });
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Image.network(
                                        doc["photo1"],
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            width: 120.0,
                                            child: Text(
                                              doc["business_name"],
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
                                                  doc["price"] + " บาท",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          doc["address"],
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                          "⭐ : " +
                                              doc["rating"].toStringAsFixed(1) +
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
                                              color:
                                                  Theme.of(context).accentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              doc["day"],
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            padding: EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).accentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              doc["time"],
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          doc["open"] == "true"
                                              ? Container(
                                                  padding: EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
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
                                                        BorderRadius.circular(
                                                            10.0),
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
                      )
                    : Visibility(
                        child: Center(
                          child: Text("ไม่มีข้อมูล"),
                        ),
                        visible: false);
              }).toList(),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BusinessAdd())), // ไปหน้าเพอ่มสถานที่
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        widget.type,
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchText = "";
      print(_searchText);
      _searchQuery.clear();
    });
  }
}
