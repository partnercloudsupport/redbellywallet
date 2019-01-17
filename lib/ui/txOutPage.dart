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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (MyApp.servers.length == 0 || MyApp.client == null) {
      return;
    }
    MyApp.client.servers = MyApp.servers;
    _loading = true;
    MyApp.client.getAccountTxOut().then((value) {
      setState(() {
        _outTx = value;
        _loading = false;
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
          itemCount: _outTx.length,
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
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Receiver: ${base64Encode(_outTx[index].address)}',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Value: ${_outTx[index].value}",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
