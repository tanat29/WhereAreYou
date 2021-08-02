// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:noppon/Business/business_list.dart';
import 'package:noppon/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  Location _location = Location();
  List<Marker> mymarker = [];
  var user_id, email, password, photo, username, tel, type;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _asyncMethod();
    }
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

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      setState(() {
        mymarker = [];
        mymarker.add(Marker(
            infoWindow: InfoWindow(title: "คุณอยู่ที่นี่", snippet: "Tes"),
            markerId: MarkerId("Test"),
            position: LatLng(l.latitude!, l.longitude!)));
      });
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  //14.0364934,100.7243904 คณะวิศวกรรมศาสตร์ มหาวิทยาลัยเทคโนโลยีราชมงคลธัญบุรี

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('หน้าหลัก'),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              children: <Widget>[
                Container(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: _initialcameraposition),
                    mapType: MapType.normal,
                    markers: Set.from(mymarker),
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text('ค้นหาร้านและสถานที่',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold))),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop1.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "ร้านอาหาร"),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop2.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "ร้านกาแฟ"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop3.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "ร้านเครื่องเขียน"),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop4.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "ร้านเสริมสวย"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop5.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "คลินิค/ขายยา"),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop6.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "ร้านทั่วไป"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop7.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "สถานที่ใน Rmutt"),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 150,
                      child: IconButton(
                        icon: Image.asset('assets/shop8.png'),
                        iconSize: 150,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Business_List(type: "สถานที่ทั่วไป"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
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
}
