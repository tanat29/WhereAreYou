import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:noppon/Model/user.dart';
import 'package:noppon/full_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class Business_Detail extends StatefulWidget {
  // รับค่ามาจากหน้าก่อน
  var place_id,
      address,
      business_name,
      business_name1,
      business_name2,
      business_name3,
      business_name_english,
      day,
      detail,
      email,
      facebook,
      instagram,
      line,
      latitude,
      longitude,
      map,
      photo1,
      photo2,
      photo3,
      photo4,
      photo5,
      photo6,
      photo7,
      photo8,
      photo9,
      photo10,
      price,
      rating,
      tel,
      time,
      type,
      user_id,
      website;

  Business_Detail({
    this.place_id,
    this.address,
    this.business_name,
    this.business_name1,
    this.business_name2,
    this.business_name3,
    this.business_name_english,
    this.day,
    this.detail,
    this.email,
    this.facebook,
    this.instagram,
    this.line,
    this.latitude,
    this.longitude,
    this.map,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo5,
    this.photo6,
    this.photo7,
    this.photo8,
    this.photo9,
    this.photo10,
    this.price,
    this.rating,
    this.tel,
    this.time,
    this.type,
    this.user_id,
    this.website,
  });

  @override
  _Business_Detail createState() => _Business_Detail();
}

class _Business_Detail extends State<Business_Detail> {
  //ประกาศตัวแปร
  var user_id, user_type;
  bool isLiked = false;
  late double rating = 5;
  TextEditingController commentController = new TextEditingController();

  late GoogleMapController _controller;
  Location _location = Location();
  List<Marker> mymarker = [];
  DateTime now = new DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    user_type = prefs.getString('type');

    //เช็คว่ากด Like ไว้รึยัง
    final snapshot = await FirebaseFirestore.instance
        .collection("like")
        .where('place_id', isEqualTo: widget.place_id)
        .where('user_id', isEqualTo: user_id)
        .get();

    setState(() {
      if (snapshot.docs.length == 0) {
        //ถ้ายังไม่กดแล้ว
        isLiked = false;
      } else {
        //ถ้ากดแล้ว
        isLiked = true;
      }
    });
  }

  //กด Like
  LikeMethod(String like) {
    if (like == "like") {
      // ถ้ากด Like อยุ่ จะทำการ Unlike
      FirebaseFirestore.instance
          .collection('like')
          .where('place_id', isEqualTo: widget.place_id)
          .where('user_id', isEqualTo: user_id)
          .limit(1)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) async {
          var Like_id = result.data()["like_id"];
          FirebaseFirestore.instance.collection("like").doc(Like_id).delete();
        });
      });
    } else {
      // ถ้ายังไม่ Like ให้กด Like
      FirebaseFirestore.instance.collection('like').add({
        'place_id': widget.place_id,
        'user_id': user_id,
      }).then((value) => FirebaseFirestore.instance
          .collection('like')
          .doc(value.id)
          .update({'like_id': value.id}));
    }
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    // ระบบแผนที่
    setState(() {
      _markers.clear();

      final marker = Marker(
        markerId: MarkerId(widget.business_name),
        position: LatLng(widget.latitude as double, widget.longitude as double),
        infoWindow: InfoWindow(
          title: widget.business_name,
          snippet: widget.address,
        ),
      );
      _markers["Test"] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat.MMMd('th');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.business_name),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // ส่งค่าไปยัง GetPhotoArray
          GetPhotoArray(
              widget.photo1,
              widget.photo2,
              widget.photo3,
              widget.photo4,
              widget.photo5,
              widget.photo6,
              widget.photo7,
              widget.photo8,
              widget.photo9,
              widget.photo10),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    widget.business_name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      child: IconButton(
                        iconSize: 35,
                        icon: Image.asset('assets/btn_marker.png'),
                        onPressed: () async {
                          if (await canLaunch(widget.map))
                            await launch(widget.map);
                          else
                            throw "Could not launch $widget.google_map";
                        },
                      ),
                    ),
                    Visibility(
                        child: Container(
                          child: IconButton(
                            iconSize: 35,
                            icon: isLiked == false
                                ? Image.asset('assets/btn_like_gray.png')
                                : Image.asset('assets/btn_like_red.png'),
                            //icon: Image.asset('assets/btn_like_gray.png'),
                            onPressed: () {
                              // ถ้า Like จะสีแดง ถ้าไม่ Like จะสีเทา
                              setState(() {
                                if (isLiked == true) {
                                  LikeMethod("like");
                                  isLiked = false;
                                } else {
                                  LikeMethod("unlike");
                                  isLiked = true;
                                }
                              });
                            },
                          ),
                        ),
                        visible: user_type == 'ผู้ประกอบการ' ? false : true),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Container(
              child: Text("⭐ : " + widget.rating.toString() + "/5.0",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('ที่อยู่ :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.address,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('English :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.business_name_english,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('ประเภท :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.type,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('เบอร์โทร :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.tel,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('เวลา :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.time,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('ราคา :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.price,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('เว็บไซต์ :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.website,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('Facebook :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.facebook,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('Instagram :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.instagram,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('อีเมลล์ :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.email,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('Line :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.line,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 81,
                  child: Text('ที่อยู่ :',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                  child: Text(widget.address,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 200,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.latitude as double, widget.longitude as double),
                zoom: 15,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
          Divider(color: Colors.black),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text('รายละเอียด',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
            child: Text(
              widget.detail,
              softWrap: true,
            ),
          ),
          Divider(color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text('ความคิดเห็น',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold)),
              ),
              user_type == "ผู้ใช้ทั่วไป"
                  ? Container(
                      margin: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('แสดงความคิดเห็น'),
                                  content: Wrap(children: [
                                    new RatingBar(
                                      initialRating: rating,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      onRatingUpdate: (rating1) {
                                        setState(() {
                                          rating = rating1;
                                          print(rating1);
                                        });
                                      },
                                      ratingWidget: RatingWidget(
                                        full: Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        half: Icon(
                                          Icons.star_half,
                                          color: Colors.amber,
                                        ),
                                        empty: Icon(
                                          Icons.star_outline,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                    new TextFormField(
                                      maxLines: 1,
                                      autofocus: false,
                                      controller: commentController,
                                      decoration: new InputDecoration(
                                        hintText: 'กรุณาใส่ข้อความ',
                                      ),
                                    ),
                                  ]),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () async {
                                          final snapshot =
                                              await FirebaseFirestore.instance
                                                  .collection("comment")
                                                  .get();
                                          if (snapshot.docs.length == 0) {
                                            // เพิ่ม Comment
                                            FirebaseFirestore.instance
                                                .collection('comment')
                                                .add({
                                              'array': 1,
                                              'comment_id': "",
                                              'comment': commentController.text,
                                              'place_id': widget.place_id,
                                              'user_id': user_id,
                                              'day':
                                                  '${formatter.format(now) + ' ${now.year + 543}'}',
                                              'rating': rating.toInt(),
                                            }).then((value) => FirebaseFirestore
                                                        .instance
                                                        .collection('comment')
                                                        .doc(value.id)
                                                        .update({
                                                      'comment_id': value.id
                                                    }));
                                          } else {
                                            // เพิ่ม Comment
                                            FirebaseFirestore.instance
                                                .collection('comment')
                                                .orderBy('array',
                                                    descending: true)
                                                .limit(1)
                                                .get()
                                                .then((querySnapshot) {
                                              querySnapshot.docs
                                                  .forEach((result) async {
                                                var array =
                                                    result.data()['array'] + 1;

                                                FirebaseFirestore.instance
                                                    .collection('comment')
                                                    .add({
                                                  'array': array,
                                                  'comment_id': "",
                                                  'comment':
                                                      commentController.text,
                                                  'place_id': widget.place_id,
                                                  'user_id': user_id,
                                                  'day':
                                                      '${formatter.format(now) + ' ${now.year + 543}'}',
                                                  'rating': rating.toInt(),
                                                }).then((value) =>
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'comment')
                                                            .doc(value.id)
                                                            .update({
                                                          'comment_id': value.id
                                                        }));

                                                //หาค่าเฉลี่ย Rating
                                                // FirebaseFirestore.instance
                                                //     .collection('comment')
                                                //     .where('place_id',
                                                //         isEqualTo:
                                                //             widget.place_id)
                                                //     .get()
                                                //     .then((querySnapshot) {
                                                //   querySnapshot.docs
                                                //       .forEach((result) async {
                                                //     double total = 0, count = 0;
                                                //     total = total +
                                                //         result.data()['rating'];
                                                //     count++;

                                                //     var average = total / count;

                                                //     FirebaseFirestore.instance
                                                //         .collection('place')
                                                //         .doc(widget.place_id)
                                                //         .update({
                                                //       'rating': average
                                                //     });
                                                //   });
                                                // });
                                              });
                                            });
                                          }

                                          List<int> rating_count = [];

                                          Navigator.of(context).pop();
                                        },
                                        child: Text("ตกลง")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("ยกเลิก")),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("แสดงความคิดเห็น",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0))),
                    )
                  : Visibility(child: Text(""), visible: false)
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('comment')
                .orderBy('array', descending: true)
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
                  itemBuilder: (ctx, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return data['place_id'] == widget.place_id
                        ? CommentList(
                            data: data,
                            user_id:
                                user_id) // ส่งค่าไปยัง CommentList เพื่อหา Username
                        : Visibility(child: Text(""), visible: false);
                  },
                );
            },
          ),
        ],
      ),
    );
  }

  // รับค่า photo มาทั้ง 10 จากนั้นคืน ImageSlide กลับไป
  GetPhotoArray(photo1, photo2, photo3, photo4, photo5, photo6, photo7, photo8,
      photo9, photo10) {
    int check_index = 0;
    List<String> photo_array = [
      photo1,
      photo2,
      photo3,
      photo4,
      photo5,
      photo6,
      photo7,
      photo8,
      photo9,
      photo10
    ];
    if (photo10.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo4,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo5,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo6,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo7,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo8,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo9,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo10,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo9.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo4,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo5,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo6,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo7,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo8,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo9,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo8.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo4,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo5,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo6,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo7,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo8,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo7.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo4,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo5,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo6,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo7,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo6.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo4,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo5,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo6,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo5.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo4,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo5,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo4.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo4,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo3.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo3,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo2.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    } else if (photo1.isNotEmpty) {
      return InkWell(
          // คืน ImageSlide กลับไป
          child: ImageSlideshow(
            width: double.infinity,
            height: 200,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              check_index = value;
            },
            autoPlayInterval: 6000,
            isLoop: true,
            children: [
              Image.network(
                photo1,
                fit: BoxFit.cover,
              ),
              Image.network(
                photo2,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImage(
                    photo: photo_array[check_index],
                  ),
                ));
          });
    }
  }
}

// แสดงข้อมูล comment
class CommentList extends StatelessWidget {
  var data, user_id;
  CommentList({this.data, this.user_id});

  // return ดาวกลับไป
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
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('user')
            .where('user_id', isEqualTo: data["user_id"])
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
                return InkWell(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                // แสดงชื่อกับวันที่
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("โดย " + document['username'],
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(data['day'],
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 16.0)),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buildRatingStars(data['rating']),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(data['comment'],
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 16.0))
                                  ],
                                ),
                              ],
                            ))),
                    onTap: () {
                      // ถ้าเป็นเจ้าของ comment สามารถลบได้
                      if (data["user_id"] == user_id) {
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
                              content:
                                  Text("คุณต้องลบความคิดเห็นนี้ ใช่หรือไม่?"),
                              actions: <Widget>[
                                // ignore: deprecated_member_use
                                FlatButton(
                                  child: Text(
                                    "ไม่ใช่",
                                    style: new TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                ),
                                // ignore: deprecated_member_use
                                FlatButton(
                                  child: Text(
                                    "ใช่",
                                    style: new TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () async {
                                    FirebaseFirestore.instance
                                        .collection('comment')
                                        .doc(data['comment_id'])
                                        .delete()
                                        .then((value) {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    });
                                    Toast.show("ลบความคิดเห็นสำเร็จ", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
              }).toList(),
            );
          }
        });
  }
}
