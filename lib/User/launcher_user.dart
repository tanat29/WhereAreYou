import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noppon/Business/business_list.dart';
import 'package:noppon/Business/business_list_user.dart';
import 'package:noppon/User/favorite.dart';
import 'package:noppon/Entrepreneur/home.dart';
import 'package:noppon/User/profile.dart';
import 'package:noppon/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Launcher_User extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _LauncherState2();
  }
}

class _LauncherState2 extends State<Launcher_User> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    Business_List_User(),
    Favorite(),
    Profile(),
  ];

  Future<bool> _onWillPop() async {
    return (await LogoutMethod(context)) ?? false;
  }

  // ฟังก์ชัน Logout
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

  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.home),
        title: Text('Home'),
        backgroundColor: Colors.blue),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite,
        ),
        title: Text('Favorite'),
        backgroundColor: Colors.blue),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.userAlt),
        title: Text('Profile'),
        backgroundColor: Colors.blue),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: _pageWidget.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: _menuBar,
            iconSize: 20,
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        ));
  }
}
