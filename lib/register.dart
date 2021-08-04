// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RegisterState();
}

class RegisterState extends State<Register> {
  // ประกาศตัวแปร
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController telController = TextEditingController();
  bool check = false;
  bool register = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String dropdownValue = 'ผู้ประกอบการ';
  List<String> user_type = ['ผู้ประกอบการ', 'ผู้ใช้ทั่วไป'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าสมัครสมาชิก"),
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
                        controller: nameController,
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
                            'สมัครสมาชิก',
                            style: new TextStyle(fontSize: 20.0),
                          ),
                          onPressed: () {
                            RegisterMethod(context);
                          }),
                    ),
                  ],
                ))));
  }

  // เช็ค format Email
  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  Future<void> RegisterMethod(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var Email = emailController.text.trim();
    var Password = passwordController.text.trim();
    var Username = nameController.text.trim();
    var Tel = telController.text.trim();
    var Type = dropdownValue;

    // Validate ข้อมูลก่อนไปสมัครสมาชิก
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

    // แสดง Progress
    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(
        message: "กรุณารอสักครู่ ...",
        progressWidget: Container(
            margin: EdgeInsets.all(10.0), child: CircularProgressIndicator()));
    pDialog.show();

    // เช็คอีเมลล์
    if (await checkIfDocExists(Email)) {
      // ถ้าอีเมลล์ซ้ำ
      Toast.show("อีเมลล์ซ้ำ กรุณาเปลี่ยนอีเมลล์", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      pDialog.hide();
      return;
    } else {
      // ถ้าอีเมลล์ไม่ซ้ำ ให้บักทึกข้อมูล
      pDialog.hide();
      CollectionReference users = FirebaseFirestore.instance.collection('user');

      users.add({
        'user_id': "",
        'email': Email,
        'password': Password,
        'username': Username,
        'photo': "",
        'tel': Tel,
        'type': Type
      }).then((value) => FirebaseFirestore.instance
          .collection('user')
          .doc(value.id)
          .update({'user_id': value.id}));

      Toast.show("สมัครสมาชิกสำเร็จ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pop(context);
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
        // ถ้าไม่ซ้ำให้เป็น false
        check = false;
      });
    } else {
      setState(() {
        // ถ้าซ้ำให้เป็น true
        check = true;
      });
    }
    return check;
  }
}
