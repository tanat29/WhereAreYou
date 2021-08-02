// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noppon/Model/place.dart';
import 'package:noppon/Model/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class BusinessAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new BusinessAddState();
}

class BusinessAddState extends State<BusinessAdd> {
  final business_name_Controller = TextEditingController();
  final business_name1_Controller = TextEditingController();
  final business_name2_Controller = TextEditingController();
  final business_name3_Controller = TextEditingController();
  final business_name_english_Controller = TextEditingController();
  final tel_Controller = TextEditingController();
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

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

// TextEditingController business_name_Controller = TextEditingController();
//   TextEditingController business_name1_Controller = TextEditingController();
//   TextEditingController business_name2_Controller = TextEditingController();
//   TextEditingController business_name3_Controller = TextEditingController();
//   TextEditingController business_name_english_Controller =
//       TextEditingController();
//   TextEditingController tel_Controller = TextEditingController();
//   TextEditingController time_Controller = TextEditingController();
//   TextEditingController price_Controller = TextEditingController();
//   TextEditingController website_Controller = TextEditingController();
//   TextEditingController facebook_Controller = TextEditingController();
//   TextEditingController instagram_Controller = TextEditingController();
//   TextEditingController email_Controller = TextEditingController();
//   TextEditingController address_Controller = TextEditingController();
//   TextEditingController detail_Controller = TextEditingController();
//   TextEditingController google_map_Controller = TextEditingController();

  Future<void> BusinessAddMethod(BuildContext context) async {
    var Business_name = business_name_Controller.text.trim();
    var Business_name1 = business_name1_Controller.text.trim();
    var Business_name2 = business_name2_Controller.text.trim();
    var Business_name3 = business_name3_Controller.text.trim();
    var Business_name_english = business_name_english_Controller.text.trim();
    var Tel = tel_Controller.text.trim();
    var Time = time_Controller.text.trim();
    var Price = price_Controller.text.trim();
    var Website = website_Controller.text.trim();
    var Facebook = facebook_Controller.text.trim();
    var Instagram = instagram_Controller.text.trim();
    var Line = line_Controller.text.trim();
    var Email = email_Controller.text.trim();
    var Address = address_Controller.text.trim();
    var Detail = detail_Controller.text.trim();
    var Google_map = google_map_Controller.text.trim();
    var Type = dropdownValue;
    double Latitude = latitude_Controller as double;
    double Longitude = longitude_Controller as double;

    if (Business_name.isEmpty) {
      Toast.show("กรุณาใส่ชื่อร้านก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Tel.isEmpty) {
      Toast.show("กรุณาใส่เบอร์โทรก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Time.isEmpty) {
      Toast.show("กรุณาใส่เวลาก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Price.isEmpty) {
      Toast.show("กรุณาใส่ราคาก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Website.isEmpty) {
      Toast.show("กรุณาใส่เว็บไซต์ก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Facebook.isEmpty) {
      Toast.show("กรุณาใส่เฟสบุคก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Email.isEmpty) {
      Toast.show("กรุณาใส่อีเมลล์ก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (validateEmail(Email) == false) {
      Toast.show('กรุณาตรวจสอบอีเมลล์ให้ถูกต้อง', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Address.isEmpty) {
      Toast.show("กรุณาใส่ที่อยู่ก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Google_map.isEmpty) {
      Toast.show("กรุณาใส่ลิ้งค์ Google Map ก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Tel.isEmpty) {
      Toast.show("กรุณาใส่เบอร์โทรก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(message: 'กรุณารอสักครู่...');
    pDialog.show();

    CollectionReference db = FirebaseFirestore.instance.collection('place');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var User_id = prefs.getString('user_id').toString();

    // Place data = Place(
    //     "",
    //     Address,
    //     Business_name,
    //     Business_name1,
    //     Business_name2,
    //     Business_name3,
    //     Business_name_english,
    //     "day",
    //     Detail,
    //     Email,
    //     Facebook,
    //     Instagram,
    //     Line,
    //     Latitude,
    //     Longitude,
    //     Google_map,
    //     "Open",
    //     "Photo",
    //     Price,
    //     5,
    //     "true",
    //     Tel,
    //     Time,
    //     Type,
    //     User_id,
    //     Website);

    // db.add(data).then((value) => FirebaseFirestore.instance
    //     .collection('place')
    //     .doc(value.id)
    //     .update({'place_id': value.id}).then(
    //         (value) => Navigator.pop(context)));

    pDialog.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าเพิ่มสถานที่"),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                alignment: Alignment.center,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ชื่อ",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: business_name_Controller,
                        decoration: new InputDecoration(
                          hintText: 'กรุณาใส่ชื่อ',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ชื่อแฝง 1 (Alias Name)",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        controller: business_name1_Controller,
                        decoration: new InputDecoration(
                          hintText: 'กรุณาใส่ชื่อแฝง 1',
                        ),
                        validator: (val) => val!.length < 5
                            ? 'รหัสผ่านต้องมีอย่างน้อย 6 ตัว'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ชื่อแฝง 2 (Alias Name)",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: business_name2_Controller,
                        decoration: new InputDecoration(
                          hintText: 'กรุณาใส่ชื่อแฝง 2',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ชื่อแฝง 3 (Alias Name)",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: business_name3_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ชื่อแฝง 3'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "English",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: business_name_english_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ English'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ประเภท",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "เบอร์โทร",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: tel_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่เบอร์โทร'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "เวลาเปิด-ปิด",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: time_Controller,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            hintText: 'กรุณาใส่เวลาเปิดปิด'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ช่วงราคา",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: price_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ช่วงราคา'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "เว็บไซต์",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: website_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่เว็บไซต์'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Facebook",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: facebook_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ Facebook'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Instagram",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: instagram_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ Instagram'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "อีเมลล์",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: email_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่อีเมลล์'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Line",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: line_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ Line'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ที่อยู่",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: address_Controller,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ที่อยู่'),
                      ),
                    ),
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
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ละติจูด'),
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
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่ลองจิจูด'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "รายละเอียดร้าน",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: detail_Controller,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ตำแหน่งสถานที่",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: google_map_Controller,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            hintText: 'ตัวอย่าง www.google.com/asdfad'),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton(
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
                            BusinessAddMethod(context);
                          }),
                    ),
                  ],
                ))));
  }

  // Future<String> signUp(String email, String password) async {
  //   AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
  //       email: email, password: password);
  //   FirebaseUser user = result.user;
  //   return user.uid;
  // }

}
