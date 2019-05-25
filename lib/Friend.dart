import 'package:flutter/material.dart';

class Friend extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend'),
      ),
      body: Column(children: <Widget>[
        Center(child: Text('Friend')),
        ],
      ),
    );
  }
}