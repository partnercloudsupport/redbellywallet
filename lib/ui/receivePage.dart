import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:redbellywallet/main.dart';

class ReceivePage extends StatefulWidget {
  ReceivePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReceivePageState createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  double _imageSize = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: Center(
        child: QrImage(
          data: base64Encode(MyApp.client.account.address),
          size: _imageSize,
        ),
      ),
    );
  }
}
