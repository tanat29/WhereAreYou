// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:toast/toast.dart';

//final db = FirebaseDatabase.instance.reference().child("user");

class Dropdown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DropdownState();
}

class DropdownState extends State<Dropdown> {
  String dropdownValue = 'One';

  List<String> spinnerItems = ['One', 'Two', 'Three', 'Four', 'Five'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: <Widget>[
          DropdownButton<String>(
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.red, fontSize: 18),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            value: dropdownValue,
            onChanged: (data) {
              setState(() {
                dropdownValue = data!;
              });
            },
            items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Text('Selected Item = ' + '$dropdownValue',
              style: TextStyle(fontSize: 22, color: Colors.black)),
        ]),
      ),
    );
  }
}
