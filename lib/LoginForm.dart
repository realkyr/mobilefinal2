import 'package:flutter/material.dart';
import './Register.dart';
import './Home.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController user = TextEditingController();
  final TextEditingController password = TextEditingController();

  void _login(BuildContext context) async {
    if (user.text == '' || password.text == '') {
      final snackBar = SnackBar(
        content: Text('กรุณาระบุ Username or Password'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else if (user.text == 'admin' && password.text == 'admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      final snackBar = SnackBar(
        content: Text('อีเมล์ไม่ถูกต้อง'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
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
