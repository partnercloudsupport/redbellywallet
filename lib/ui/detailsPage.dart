import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget{
  DetailsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Details Page", textAlign: TextAlign.center, style: TextStyle(
            fontSize: 40.0,
            color: Colors.red,
          ),),
        ),
      ],
    );
  }
}