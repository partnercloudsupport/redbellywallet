import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget{
  PaymentPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Payment Page", textAlign: TextAlign.center, style: TextStyle(
            fontSize: 40.0,
            color: Colors.red,
          ),),
        ),
      ],
    );
  }
}