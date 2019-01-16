import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget{
  ContactPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Contact Page", textAlign: TextAlign.center, style: TextStyle(
            fontSize: 40.0,
            color: Colors.red,
          ),),
        ),
      ],
    );
  }
}