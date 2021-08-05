// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noppon/Entrepreneur/launcher.dart';
import 'package:noppon/User/launcher_user.dart';
import 'package:noppon/User/profile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class EditUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/profile': (BuildContext context) => new Profile()
      },
      home: new EditUser1(),
    );
  }
}

class EditUser1 extends StatefulWidget {
  // รับค่ามาจากหน้าก่อน
  var user_id, email, password, username, photo, tel, type;
  EditUser1(
      {this.user_id,
      this.email,
      this.password,
      this.username,
      this.photo,
      this.tel,
      this.type});

  @override
  State<StatefulWidget> createState() => new EditUserState();
}

class EditUserState extends State<EditUser1> {
  // ประกาศตัวแปร
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController telController = TextEditingController();

  var email, password, username;

  @override
  void initState() {
    super.initState();
    // set ค่าที่รับมา
    emailController.text = widget.email;
    passwordController.text = widget.password;
    usernameController.text = widget.username;
    telController.text = widget.tel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ตรวจสอบอีเมลล์
  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  //ประกาศตัวแปร
  String dropdownValue = 'ผู้ประกอบการ';
  List<String> user_type = ['ผู้ประกอบการ', 'ผู้ใช้ทั่วไป'];

  Future<void> EditUserMethod(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var Email = emailController.text.trim();
    var Password = passwordController.text.trim();
    var Username = usernameController.text.trim();
    var Tel = telController.text.trim();
    var Type = dropdownValue;

    // validate ข้อมูล
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

    if (Password.isEmpty) {
      Toast.show("กรุณาใส่รหัสผ่านก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Password.length < 5) {
      Toast.show("รหัสผ่านต้องมากกว่า 6 ตัว", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Username.isEmpty) {
      Toast.show("กรุณาใส่ชื่อก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Tel.isEmpty) {
      Toast.show("กรุณาใส่เบอร์โทรก่อน", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    // แสดง Preogress
    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(
        message: "กรุณารอสักครู่ ...",
        progressWidget: Container(
            margin: EdgeInsets.all(10.0), child: CircularProgressIndicator()));
    pDialog.show();

    if (widget.email == Email) {
      // อัปเดตข้อมูล
      FirebaseFirestore.instance.collection('user').doc(widget.user_id).update({
        'user_id': widget.user_id,
        'email': Email,
        'password': Password,
        'username': Username,
        'tel': Tel,
        'type': Type
      }).then((value) async {
        pDialog.hide();
        // update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', Email);
        await prefs.setString('password', Password);
        await prefs.setString('username', Username);
        await prefs.setString('tel', Tel);
        await prefs.setString('type', Type);
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Launcher(),
        ),
        (route) => false,
      );
    } else if (await checkIfDocExists(Email)) {
      Toast.show("อีเมลล์ซ้ำ กรุณาเปลี่ยนอีเมลล์", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      pDialog.hide();
      return;
    }
  }

  // เช็คอีเมลล์ว่าซ้ำหรือไม่
  Future<bool> checkIfDocExists(String email) async {
    bool check = false;
    final snapshot = await FirebaseFirestore.instance
        .collection("user")
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.length == 0) {
      setState(() {
        check = false;
      });
    } else {
      setState(() {
        check = true;
      });
    }
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าแก้ไขข้อมูลผู้ใช้"),
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
                        "อีเมลล์",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        controller: emailController,
                        decoration: new InputDecoration(
                          hintText: 'กรุณาใส่อีเมลล์',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "รหัสผ่าน",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: new TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        controller: passwordController,
                        decoration: new InputDecoration(
                          hintText: 'กรุณาใส่รหัสผ่าน',
                        ),
                        validator: (val) => val!.length < 5
                            ? 'รหัสผ่านต้องมีอย่างน้อย 6 ตัว'
                            : null,
                      ),
                    ),
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
                        controller: usernameController,
                        decoration: new InputDecoration(
                          hintText: 'กรุณาใส่ชื่อ',
                        ),
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
                        controller: telController,
                        keyboardType: TextInputType.number,
                        decoration:
                            new InputDecoration(hintText: 'กรุณาใส่เบอร์โทร'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "ประเภทผู้ใช้",
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
                        items: user_type
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, textAlign: TextAlign.center),
                          );
                        }).toList(),
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
                            'แก้ไขข้อมูล',
                            style: new TextStyle(fontSize: 20.0),
                          ),
                          onPressed: () {
                            // ไปที่ EditUserMethod
                            EditUserMethod(context);
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
