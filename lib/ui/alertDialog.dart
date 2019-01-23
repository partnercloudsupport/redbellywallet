import 'package:flutter/material.dart';

class SimpleAlertDialog extends StatelessWidget {
  String title;
  String content;

  double _titleSize = 20.0;
  double _contentSize = 15.0;

  SimpleAlertDialog({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: TextStyle(
          color: Colors.red,
          fontSize: _titleSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        this.content,
        style: TextStyle(fontSize: _contentSize),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "close",
              style: TextStyle(fontSize: _contentSize),
            )),
      ],
    );
  }
}
