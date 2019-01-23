import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbellywallet/main.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';
import 'package:redbellywallet/rbbclib/transaction.dart';

class TxOutPage extends StatefulWidget {
  TxOutPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _TxOutPageState();
}

class _TxOutPageState extends State<TxOutPage> {
  List<TxOut> _outTx = List();
  int _size = 0;
  double _fontSize = 15;

  @override
  void initState() {
    super.initState();
    if (MyApp.servers.length == 0 || MyApp.client == null) {
      return;
    }
    MyApp.client.servers = MyApp.servers;
    MyApp.client.getAccountTxOut().then((value) {
      setState(() {
        _outTx = value;
        _size = _outTx.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: _size,
          itemBuilder: (context, int index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              decoration: BoxDecoration(
                border: new Border(
                  bottom: new BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Receiver:',
                    style: TextStyle(
                      fontSize: _fontSize,
                    ),
                  ),
                  Text(
                      "${base64Encode(_outTx[_size-1-index].address)}",
                    style: TextStyle(
                      fontSize: _fontSize,
                    ),
                  ),
                  Text(
                    "Value: ${_outTx[_size-1-index].value}",
                    style: TextStyle(
                      fontSize: _fontSize,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
