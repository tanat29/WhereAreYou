import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:noppon/Model/place.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class BusinessEdit extends StatefulWidget {
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

  BusinessEdit({
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
  _BusinessEdit createState() => _BusinessEdit();
}

class _BusinessEdit extends State<BusinessEdit> {
  // ประกาศตัวแปร
  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

  final business_name_Controller = TextEditingController();
  final business_name1_Controller = TextEditingController();
  final business_name2_Controller = TextEditingController();
  final business_name3_Controller = TextEditingController();
  final business_name_english_Controller = TextEditingController();
  final tel_Controller = TextEditingController();
  final day_Controller = TextEditingController();
  final time_Controller = TextEditingController();
  final price_Controller = TextEditingController();
  final website_Controller = TextEditingController();
  final facebook_Controller = TextEditingController();
  final instagram_Controller = TextEditingController();
  final line_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final address_Controller = TextEditingController();
  final detail_Controller = TextEditingController();
  final google_map_Controller = TextEditingController();
  final latitude_Controller = TextEditingController();
  final longitude_Controller = TextEditingController();

  List<File> _image = [];
  List<String> url_image = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('place');
    business_name_Controller.text = widget.business_name;
    business_name1_Controller.text = widget.business_name1;
    business_name2_Controller.text = widget.business_name2;
    business_name3_Controller.text = widget.business_name3;
    business_name_english_Controller.text = widget.business_name_english;
    tel_Controller.text = widget.tel;
    day_Controller.text = widget.day;
    time_Controller.text = widget.time;
    price_Controller.text = widget.price;
    website_Controller.text = widget.website;
    facebook_Controller.text = widget.facebook;
    instagram_Controller.text = widget.instagram;
    line_Controller.text = widget.line;
    email_Controller.text = widget.email;
    address_Controller.text = widget.address;
    detail_Controller.text = widget.detail;
    google_map_Controller.text = widget.map;
    latitude_Controller.text = widget.latitude;
    longitude_Controller.text = widget.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสถานที่'),
      ),
      body: ListView(
        children: [
          Stack(alignment: Alignment.center, children: [
            GridView.builder(
                shrinkWrap: true,
                itemCount: _image.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_image[index]),
                            fit: BoxFit.cover)),
                  );
                  // return index == 0
                  //     ? IconButton(
                  //         icon: Icon(Icons.add),
                  //         onPressed: () => !uploading ? chooseImage() : null)
                  //     : Container(
                  //         margin: EdgeInsets.all(3),
                  //         decoration: BoxDecoration(
                  //             image: DecorationImage(
                  //                 image: FileImage(_image[index]),
                  //                 fit: BoxFit.cover)),
                  //       );
                }),
            (_image.length == 0
                ? Text("กรุณาเลือกรูป")
                : Visibility(child: Text("data"), visible: true)),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container(
                      //   child: Text(
                      //     'uploading...',
                      //     style: TextStyle(fontSize: 20),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ]),
          Container(
            height: 40,
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.all(8),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'เลือกรูป',
                  style: new TextStyle(fontSize: 16.0),
                ),
                onPressed: () => !uploading ? chooseImage() : null),
          ),
          // IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () => !uploading ? chooseImage() : null),
          Container(
              margin: EdgeInsets.all(10),
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Text(
                    "ชื่อ",
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: business_name_Controller,
                    decoration: new InputDecoration(
                      hintText: 'กรุณาใส่ชื่อ',
                    ),
                  ),
                  Text(
                    "ชื่อแฝง 1 (Alias Name)",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: business_name1_Controller,
                    decoration: new InputDecoration(
                      hintText: 'กรุณาใส่ชื่อแฝง 1',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ชื่อแฝง 2 (Alias Name)",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: business_name2_Controller,
                    decoration: new InputDecoration(
                      hintText: 'กรุณาใส่ชื่อแฝง 2',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ชื่อแฝง 3 (Alias Name)",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: business_name3_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ชื่อแฝง 3'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "English",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: business_name_english_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ English'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ประเภท",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 2,
                      ),
                      onChanged: (data) {
                        setState(() {
                          dropdownValue = data!;
                        });
                      },
                      items: business_type
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, textAlign: TextAlign.center),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "เบอร์โทร",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: tel_Controller,
                    keyboardType: TextInputType.number,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่เบอร์โทร'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "วันที่เปิดทำการ",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: day_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่วันที่เปิด'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "เวลาเปิด-ปิด",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: time_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่เวลาเปิดปิด'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ช่วงราคา",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: price_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ช่วงราคา'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "เว็บไซต์",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: website_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่เว็บไซต์'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Facebook",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: facebook_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ Facebook'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Instagram",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: instagram_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ Instagram'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "อีเมลล์",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: email_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่อีเมลล์'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Line",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: line_Controller,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(hintText: 'กรุณาใส่ Line'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ที่อยู่",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: address_Controller,
                    keyboardType: TextInputType.text,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ที่อยู่'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ละติจูด",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: latitude_Controller,
                    keyboardType: TextInputType.number,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ละติจูด'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ลองจิจูด",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: longitude_Controller,
                    keyboardType: TextInputType.number,
                    decoration:
                        new InputDecoration(hintText: 'กรุณาใส่ลองจิจูด'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "รายละเอียดร้าน",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: detail_Controller,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ตำแหน่งสถานที่",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: google_map_Controller,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        hintText: 'เช่น www.google.co.th/maps/place/asdfad'),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: EdgeInsets.all(8),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      child: Text(
                        'แก้ไขสถานที่',
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        uploadFile();
                      }),
                ],
              )),
        ],
      ),
    );
  }

  // เลือกรูปภาพ
  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (_image.length == 10) {
        Toast.show("เพิ่มรูปได้ 10 รูปเท่านั้น", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        _image.add(File(pickedFile!.path));
      }
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    print("Edit");
  }

  // validate อีเมลล์
  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  // กำหนด Dropdown
  String dropdownValue = 'ร้านอาหาร';
  List<String> business_type = [
    'ร้านอาหาร',
    'ร้านกาแฟ',
    'ร้านเครื่องเขียน',
    'ร้านเสริมสวย',
    'คลินิก/ขายยา',
    'ร้านทั่วไป',
    'สถานที่ใน Rmutt',
    'สถานที่ทั่วไป'
  ];
}
