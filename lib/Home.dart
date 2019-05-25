import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile.dart';
import 'Friend.dart';
import 'LoginForm.dart';
import './main.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String greeting = 'Hello';

  void getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      greeting = 'Hello ' + prefs.getString('name');
    });
  }

  void navToProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
  }

  void navToFriend() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Friend()));
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();
    getName();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(shrinkWrap: true, children: <Widget>[
            Text(
              greeting,
              style: new TextStyle(
                fontSize: 20.0,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: double.infinity, minHeight: 50),
              child: Builder(
                  builder: (context) => RaisedButton(
                        onPressed: () => navToProfile(),
                        child: Text('PROFILE SETUP',
                            style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.blueGrey,
                      )),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: double.infinity, minHeight: 50),
              child: Builder(
                  builder: (context) => RaisedButton(
                        onPressed: () => navToFriend(),
                        child: Text('MY FRIENDS',
                            style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.blueGrey,
                      )),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: double.infinity, minHeight: 50),
              child: Builder(
                  builder: (context) => RaisedButton(
                        onPressed: () => signOut(),
                        child: Text('SIGN OUT',
                            style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.blueGrey,
                      )),
            ),
          ]),
        ));
  }
}
