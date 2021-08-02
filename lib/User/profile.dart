import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:noppon/edit_user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:transparent_image/transparent_image.dart';
import '../login.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  final db = FirebaseDatabase.instance.reference().child("user");
  var user_id, email, password, photo, username, tel, type;
  late File _image;

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
      user_id = prefs.getString('user_id');
      email = prefs.getString('email');
      password = prefs.getString('password');
      photo = prefs.getString('photo');
      username = prefs.getString('username');
      tel = prefs.getString('tel');
      type = prefs.getString('type');
    });
  }

  SetImage() {
    try {
      if (photo == "") {
        return Image.network(
          'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png',
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(photo, fit: BoxFit.cover);
      }
    } on Exception catch (_) {}
  }

  LogoutMethod(BuildContext context) async {
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

  Future getImageDevice() async {
    final _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.gallery);

    print("getImage");

    setState(() {
      _image = File(image!.path);
      uploadPic(_image);
    });
  }

  Future uploadPic(File _image) async {
    print("upload");
    var storage = FirebaseStorage.instance;

    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(
        message: "กรุณารอสักครู่...",
        progressWidget: Container(
            padding: EdgeInsets.all(5.0), child: CircularProgressIndicator()));
    pDialog.show();

    if (_image == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเลือกรูปก่อน')));
      pDialog.hide();
      return;
    } else {
      String fileName =
          new DateFormat('dd-MM-yyyy_kk:mm:ss').format(DateTime.now()) + ".jpg";

      TaskSnapshot snapshot =
          await storage.ref().child("User/$fileName").putFile(_image);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        pDialog.hide();
        print(downloadUrl);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var User_id = prefs.getString("user_id");
        var photo_before = prefs.getString("photo");

        if (photo_before != "") {
          FirebaseStorage.instance.refFromURL(photo_before!).delete();
        }

        prefs.setString('photo', downloadUrl);
        FirebaseFirestore.instance
            .collection('user')
            .doc(User_id)
            .update({'photo': downloadUrl});

        setState(() {
          photo = downloadUrl;
        });
      } else {
        print('Error from image repo ${snapshot.state.toString()}');
        throw ('This file is not an image');
      }

      //   // pDialog.hide();
      //   // Toast.show("อัพโหลดรูปสำเร็จ", context,
      //   //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(title: new Text('หน้าข้อมูลผู้ใช้งาน')),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: 0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.camera,
                          size: 25.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0xff476cfb),
                    child: ClipOval(
                      child: new SizedBox(
                          width: 120,
                          height: 120,
                          child: (photo != "")
                              ? Image.network('${photo}', fit: BoxFit.cover)
                              : Image.asset(
                                  "assets/logo.png",
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 25.0,
                      ),
                      onPressed: () {
                        getImageDevice();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 55,
                    child: Text('อีเมลล์ :',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                    child: Text(email == null ? "" : email,
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
                    width: 65,
                    child: Text('รหัสผ่าน :',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(password == null ? "" : password,
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
                    width: 60,
                    child: Text('ชื่อผู้ใช้ :',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(username == null ? "" : username,
                        style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 67,
                    child: Text('เบอร์โทร :',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(tel == null ? "" : tel,
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
                    width: 65,
                    child: Text('ประเภท :',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(type == null ? "" : type,
                        style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUser1(
                              user_id: user_id,
                              email: email,
                              password: password,
                              username: username,
                              tel: tel,
                              type: type)),
                    );
                  },
                  label: Text('แก้ไขข้อมูล'),
                  icon: Icon(Icons.edit),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                )),
            Container(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    LogoutMethod(context);
                  },
                  label: Text('ออกจากระบบ'),
                  icon: Icon(Icons.close),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
