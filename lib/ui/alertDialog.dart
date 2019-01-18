import 'package:flutter/material.dart';

class SimpleAlertDialog extends StatelessWidget {
  String title;
  String content;

  SimpleAlertDialog({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: TextStyle(
          color: Colors.red,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        this.content,
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "close",
              style: TextStyle(fontSize: 20),
            )),
      ],
    );
  }
}
