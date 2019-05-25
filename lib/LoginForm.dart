import 'package:flutter/material.dart';
import './Register.dart';
import './Models/DBProvider.dart';
import './Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Home.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController user = TextEditingController();
  final TextEditingController password = TextEditingController();

  DBProvider _db = DBProvider();

  void _login(BuildContext context) async {
    if (user.text == '' || password.text == '') {
      final snackBar = SnackBar(
        content: Text('Please fill out this form'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    User currentUser = await _db.getUserByUsername(user.text);
    if (currentUser == null || currentUser.password != password.text) {
      final snackBar = SnackBar(
        content: Text('Invalid user or password'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      print('Yeah Login!');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userid', currentUser.username);
      prefs.setString('name', currentUser.name);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
      // print(currentUser.username);
      // print(currentUser.name);
      // print('=== from prefs ===');
      // print(prefs.getString('userid'));
    }
  }

  @override
  void initState() {
    super.initState();
    _db.initDB();
    isUserLogin();
  }

  void isUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    if (prefs.getString('userid') != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Image.asset(
          'assets/food.jpg',
          height: 180,
        ),
        Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'User ID',
                ),
                controller: user,
              ),
            )),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              leading: Icon(Icons.lock_outline),
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password',
                ),
                controller: password,
                obscureText: true,
              ),
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              onPressed: () => this._login(context),
              child: Text('Login'),
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text("Register New Account",
                    style: TextStyle(color: Colors.blue)),
              ),
            ))
      ],
    );
  }
}
