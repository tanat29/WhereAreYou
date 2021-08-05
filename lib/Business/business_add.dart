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

class BusinessAdd extends StatefulWidget {
  @override
  _BusinessAdd createState() => _BusinessAdd();
}

class _BusinessAdd extends State<BusinessAdd> {
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
    // กำหนด Firestore
    imgRef = FirebaseFirestore.instance.collection('place');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสถานที่'),
      ),
      body: ListView(
        children: [
          Stack(alignment: Alignment.center, children: [
            // แสดงรูปเป็น Grid
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
                : Visibility(child: Text("data"), visible: false)),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                onPressed: () => !uploading
                    ? chooseImage()
                    : null), // กดปุ่มเลือกรูปแล้วไป chooseImage
          ),
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
                        'เพิ่มสถานที่',
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

  // ฟังก์ชันการเพิ่มสถานที่
  Future uploadFile() async {
    FocusScope.of(context).unfocus();
    var Business_name = business_name_Controller.text.trim();
    var Business_name1 = business_name1_Controller.text.trim();
    var Business_name2 = business_name2_Controller.text.trim();
    var Business_name3 = business_name3_Controller.text.trim();
    var Business_name_english = business_name_english_Controller.text.trim();
    var Tel = tel_Controller.text.trim();
    var Day = day_Controller.text.trim();
    var Time = time_Controller.text.trim();
    var Price = price_Controller.text.trim();
    var Website = website_Controller.text.trim();
    var Facebook = facebook_Controller.text.trim();
    var Instagram = instagram_Controller.text.trim();
    var Line = line_Controller.text.trim();
    var Email = email_Controller.text.trim();
    var Address = address_Controller.text.trim();
    var Latitude = latitude_Controller.text.trim();
    var Longitude = longitude_Controller.text.trim();
    var Detail = detail_Controller.text.trim();
    var Google_map = google_map_Controller.text.trim();
    var Type = dropdownValue;

    //  validate อีเมลล์
    if (validateEmail(Email) == false) {
      Toast.show('กรุณาตรวจสอบอีเมลล์ให้ถูกต้อง', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    int i = 0;
    // แสดง Progress
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Download,
        isDismissible: false,
        showLogs: false);
    for (var img in _image) {
      setState(() {
        val = i / _image.length;

        pr.update(
            message: 'กรุณารอสักครู่ ...',
            progressWidget: Container(
                margin: EdgeInsets.all(10.0),
                child: CircularProgressIndicator()),
            progress: double.parse((val * 100).toStringAsFixed(0)),
            maxProgress: 100,
            progressTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.w400));
        pr.show();
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((url) {
          // เพิ่ม Url รูปลง url_image
          url_image.add(url);
          i++;
        });
      });
    }

    print(i);
    var photo10,
        photo9,
        photo8,
        photo7,
        photo6,
        photo5,
        photo4,
        photo3,
        photo2,
        photo1;

    // กำหนด photo ทั้ง 10
    if (i == 10) {
      photo10 = url_image[9];
      photo9 = url_image[8];
      photo8 = url_image[7];
      photo7 = url_image[6];
      photo6 = url_image[5];
      photo5 = url_image[4];
      photo4 = url_image[3];
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 9) {
      photo10 = "";
      photo9 = url_image[8];
      photo8 = url_image[7];
      photo7 = url_image[6];
      photo6 = url_image[5];
      photo5 = url_image[4];
      photo4 = url_image[3];
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 8) {
      photo10 = "";
      photo9 = "";
      photo8 = url_image[7];
      photo7 = url_image[6];
      photo6 = url_image[5];
      photo5 = url_image[4];
      photo4 = url_image[3];
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 7) {
      photo10 = "";
      photo9 = "";
      photo8 = "";
      photo7 = url_image[6];
      photo6 = url_image[5];
      photo5 = url_image[4];
      photo4 = url_image[3];
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 6) {
      photo10 = "";
      photo9 = "";
      photo8 = "";
      photo7 = "";
      photo6 = url_image[5];
      photo5 = url_image[4];
      photo4 = url_image[3];
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 5) {
      photo10 = "";
      photo9 = "";
      photo8 = "";
      photo7 = "";
      photo6 = "";
      photo5 = url_image[4];
      photo4 = url_image[3];
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 4) {
      photo10 = "";
      photo9 = "";
      photo8 = "";
      photo7 = "";
      photo6 = "";
      photo5 = "";
      photo4 = url_image[3];
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 3) {
      photo10 = "";
      photo9 = "";
      photo8 = "";
      photo7 = "";
      photo6 = "";
      photo5 = "";
      photo4 = "";
      photo3 = url_image[2];
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 2) {
      photo10 = "";
      photo9 = "";
      photo8 = "";
      photo7 = "";
      photo6 = "";
      photo5 = "";
      photo4 = "";
      photo3 = "";
      photo2 = url_image[1];
      photo1 = url_image[0];
    } else if (i == 1) {
      photo10 = "";
      photo9 = "";
      photo8 = "";
      photo7 = "";
      photo6 = "";
      photo5 = "";
      photo4 = "";
      photo3 = "";
      photo2 = "";
      photo1 = url_image[0];
    }

    // รับค่า user_id มา
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var User_id = prefs.getString('user_id').toString();

    int array = 0;
    final snapshot = await FirebaseFirestore.instance.collection("place").get();
    if (snapshot.docs.length == 0) {
      //กรณี array เป็น 0
      array = 0;

      // เพิ่มข้อมูลลง Firestore
      imgRef
          .add({
            'address': Address,
            'array': array,
            'business_name': Business_name,
            'business_name1': Business_name1,
            'business_name2': Business_name2,
            'business_name3': Business_name3,
            'business_name_english': Business_name_english,
            'day': Day,
            'detail': Detail,
            'email': Email,
            'facebook': Facebook,
            'instagram': Instagram,
            'latitude': double.parse('$Latitude'),
            'line': Line,
            'longitude': double.parse('$Longitude'),
            'map': Google_map,
            'open': "true",
            'photo1': photo1,
            'photo2': photo2,
            'photo3': photo3,
            'photo4': photo4,
            'photo5': photo5,
            'photo6': photo6,
            'photo7': photo7,
            'photo8': photo8,
            'photo9': photo9,
            'photo10': photo10,
            'place_id': "",
            'price': Price,
            'rating': 0,
            'status': "true",
            'tel': Tel,
            'time': Time,
            'type': Type,
            'user_id': User_id,
            'website': Website
          })
          .then((value) => FirebaseFirestore.instance
              .collection('place')
              .doc(value.id)
              .update({'place_id': value.id})) // อัปเดต place_id
          .whenComplete(() async {
            pr.hide();
            Navigator.of(context).pop(); // กลับไปหน้าเดิม
          });
    } else {
      //กรณี array ไม่เป็น 0
      FirebaseFirestore.instance
          .collection('place')
          .orderBy('array', descending: true)
          .limit(1)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) async {
          array = result.data()['array'] + 1;

          // เพิ่มข้อมูล
          imgRef
              .add({
                'address': Address,
                'array': array,
                'business_name': Business_name,
                'business_name1': Business_name1,
                'business_name2': Business_name2,
                'business_name3': Business_name3,
                'business_name_english': Business_name_english,
                'day': Day,
                'detail': Detail,
                'email': Email,
                'facebook': Facebook,
                'instagram': Instagram,
                'latitude': double.parse('$Latitude'),
                'line': Line,
                'longitude': double.parse('$Longitude'),
                'map': Google_map,
                'open': "true",
                'photo1': photo1,
                'photo2': photo2,
                'photo3': photo3,
                'photo4': photo4,
                'photo5': photo5,
                'photo6': photo6,
                'photo7': photo7,
                'photo8': photo8,
                'photo9': photo9,
                'photo10': photo10,
                'place_id': "",
                'price': Price,
                'rating': 0,
                'status': "true",
                'tel': Tel,
                'time': Time,
                'type': Type,
                'user_id': User_id,
                'website': Website
              })
              .then((value) => FirebaseFirestore.instance
                  .collection('place')
                  .doc(value.id)
                  .update({'place_id': value.id})) // อัปเดต place_id
              .whenComplete(() async {
                pr.hide();
                Navigator.of(context).pop(); // ย้อนกลับ
              });
        });
      });
    }
  }

  // validate อีเมลล์
  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  // ประกาศ List ใน dropdown
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
