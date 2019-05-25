import 'package:flutter/material.dart';
import './Models/DBProvider.dart';
import './Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  try {
    int.parse(s);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController quote = TextEditingController();

  String _usernameError = '';
  String _passwordError = '';
  String _nameError = '';
  String _ageError = '';

  DBProvider _db = DBProvider();

  void _continue(BuildContext context) async {
    print({
      'username': username.text,
      'name': name.text,
      'password': password.text,
      'age': age.text
    });

    setState(() {
      _usernameError = '';
      _passwordError = '';
      _nameError = '';
      _ageError = '';
    });

    bool isError = false;

    // validate username
    if (!(username.text.length >= 6 && username.text.length <= 12)) {
      setState(() {
        _usernameError = 'User Id ต้องมีความยาวในช่วง 6-12 ตัวอักษร';
      });
      isError = true;
    }

    // validate password
    if (password.text.length <= 6) {
      setState(() {
        _passwordError = 'Password ต้องมีความยาวมากกว่า 6 ตัวอักษร';
      });
      isError = true;
    }
    
    // validate name
    if (name.text.split(" ").length != 2 ||
        ' '.allMatches(name.text).length != 1 ||
        name.text.split(' ').contains('')) {
      setState(() {
        _nameError = 'ชื่อต้องประกอบด้วยชื่อนามสกุล ขั้นด้วย 1 space เท่านั้น';
      });
      isError = true;
    }

    // validate age
    if (!isNumeric(age.text)) {
      setState(() {
        _ageError = 'กรุณาใส่เป็นตัวเลขเท่านั้น';
      });
      isError = true;      
    }
    else {
      if (!(int.parse(age.text) >= 10 && int.parse(age.text) <= 80)) {
        _ageError = 'age ต้องอยู่ในช่วง 10-80 ปี';
        isError = true;
      }
    }

    if (isError) return;

    // if data is valid
    print('pass');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    User currentUser = await _db.getUserByUsername(prefs.getString('userid'));

    User _newUser = User(
      id: currentUser.id,
      username: username.text,
      name: name.text,
      password: password.text,
      age: int.parse(age.text)
    );
    print(_newUser.id);
    await _db.updateUser(_newUser);
    writeFile('quote', quote.text);
    Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    _db.initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(shrinkWrap: true, children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'User Id',
                  errorText: _usernameError == '' ? null : _usernameError,
                  prefixIcon: Icon(Icons.person)),
              controller: username,
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Name',
                  errorText: _nameError == '' ? null : _nameError,
                  prefixIcon: Icon(Icons.person_outline)),
              controller: name,
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Age',
                  errorText: _ageError == '' ? null : _ageError,
                  prefixIcon: Icon(Icons.calendar_today)),
              controller: age,
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Password',
                  errorText: _passwordError == '' ? null : _passwordError,
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
              controller: password,
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Quote'),
              controller: quote,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: double.infinity, minHeight: 50),
              child: Builder(
                  builder: (context) => RaisedButton(
                        onPressed: () => this._continue(context),
                        child: Text('SAVE',
                            style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.blueGrey,
                      )),
            )
          ]),
        ));
  }
}
