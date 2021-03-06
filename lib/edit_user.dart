// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController telController = TextEditingController();

  var email, password, username;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
    passwordController.text = widget.password;
    usernameController.text = widget.username;
    telController.text = widget.tel;
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

  String dropdownValue = '????????????????????????????????????';
  List<String> user_type = ['????????????????????????????????????', '????????????????????????????????????'];

  Future<void> EditUserMethod(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var Email = emailController.text.trim();
    var Password = passwordController.text.trim();
    var Username = usernameController.text.trim();
    var Tel = telController.text.trim();
    var Type = dropdownValue;

    if (Email.isEmpty) {
      Toast.show("?????????????????????????????????????????????????????????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (validateEmail(Email) == false) {
      Toast.show('???????????????????????????????????????????????????????????????????????????????????????', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Password.isEmpty) {
      Toast.show("????????????????????????????????????????????????????????????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Password.length < 5) {
      Toast.show("????????????????????????????????????????????????????????? 6 ?????????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Username.isEmpty) {
      Toast.show("????????????????????????????????????????????????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (Tel.isEmpty) {
      Toast.show("????????????????????????????????????????????????????????????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    final ProgressDialog pDialog = ProgressDialog(context);
    pDialog.style(
        message: "?????????????????????????????????????????? ...",
        progressWidget: Container(
            margin: EdgeInsets.all(10.0), child: CircularProgressIndicator()));
    pDialog.show();

    if (widget.email == Email) {
      FirebaseFirestore.instance.collection('user').doc(widget.user_id).update({
        'user_id': widget.user_id,
        'email': Email,
        'password': Password,
        'username': Username,
        'tel': Tel,
        'type': Type
      }).then((value) async {
        pDialog.hide();
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
      Toast.show("?????????????????????????????? ?????????????????????????????????????????????????????????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      pDialog.hide();
      return;
    }
  }

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
          title: Text("???????????????????????????????????????????????????????????????"),
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
                        "?????????????????????",
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
                          hintText: '?????????????????????????????????????????????',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "????????????????????????",
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
                          hintText: '????????????????????????????????????????????????',
                        ),
                        validator: (val) => val!.length < 5
                            ? '????????????????????????????????????????????????????????????????????? 6 ?????????'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "????????????",
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
                          hintText: '????????????????????????????????????',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "????????????????????????",
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
                            new InputDecoration(hintText: '????????????????????????????????????????????????'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "????????????????????????????????????",
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
                            '?????????????????????????????????',
                            style: new TextStyle(fontSize: 20.0),
                          ),
                          onPressed: () {
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
