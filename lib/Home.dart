import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'Profile.dart';
import 'Friend.dart';
import './main.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String greeting = 'Hello';
  String myQuote = 'No quote provided yet';

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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/data.txt');
  }

  Future<File> writeFile(String key, String value) async {
    final file = await _localFile;
    String data = '{"$key": "$value"}';
    print(data);
    return file.writeAsString(data); // Write the file
  }

  Future<String> readFile(String key) async {
    try {
      final file = await _localFile;
      // Read the file
      Map contents = json.decode(await file.readAsString());
      return contents[key];
    } catch (e) {
      print(e);
      return e;
    }
  }

  void getQuote() async {
    readFile('quote').then((String quote) {
      setState(() {
        myQuote = 'this is my quote "' + quote + '"';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
    getQuote();
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
            Text(myQuote),
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
