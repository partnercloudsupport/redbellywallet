import 'package:flutter/material.dart';
import 'package:redbellywallet/main.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';

class TxInPage extends StatefulWidget {
  TxInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _TxInPageState();
}

class _TxInPageState extends State<TxInPage> {
  List<IncomingTxTuple> _incomingTx = List();
  int _size = 0;
  double _fontSize = 15;

  @override
  void initState() {
    super.initState();
    if (MyApp.servers.length == 0 || MyApp.client == null) {
      return;
    }
    MyApp.client.servers = MyApp.servers;
    MyApp.client.getAccountIncomingTx().then((value) {
      setState(() {
        _incomingTx = value;
        _size = _incomingTx.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline,
        ),
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
                    'Sender:',
                    style: TextStyle(
                      fontSize: _fontSize,
                    ),
                  ),
                  Text(
                    '${_incomingTx[_size - 1 - index].sender}',
                    style: TextStyle(
                      fontSize: _fontSize,
                    ),
                  ),
                  Text(
                    "Value: ${_incomingTx[_size - 1 - index].value}",
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
