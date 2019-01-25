import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbellywallet/main.dart';

import 'txInPage.dart';
import 'txOutPage.dart';
import 'paymentPage.dart';
import 'receivePage.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _balance = 0;
  bool _loading = true;
  double _fontSize = 20.0;
  double _subFontSize = 15.0;
  double _iconSize = 40.0;

  @override
  void initState() {
    super.initState();
    if (MyApp.servers.length == 0 || MyApp.client == null) {
      return;
    }
    MyApp.client.servers = MyApp.servers;
    _loading = true;
    MyApp.client.getBalance().then((value) {
      setState(() {
        _balance = value;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget accountSection = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Row(
        children: [
          Container(
            width: 80.0,
            alignment: Alignment.center,
            child: Icon(
              Icons.account_circle,
              size: _iconSize,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Account Address',
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    MyApp.client == null
                        ? "Add Key First"
                        : base64Encode(MyApp.client.account.address),
                    style: TextStyle(
                      fontSize: _subFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget balanceSection = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Row(
        children: [
          Container(
            width: 80.0,
            alignment: Alignment.center,
            child: Icon(
              Icons.monetization_on,
              size: _iconSize,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _loading ? "N/A" : _balance.toString(),
                    style: TextStyle(
                      fontSize: _subFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              setState(() {
                if (MyApp.servers.length == 0 || MyApp.client == null) {
                  return;
                }
                MyApp.client.servers = MyApp.servers;
                _loading = true;
                MyApp.client.getBalance().then((value) {
                  setState(() {
                    _balance = value;
                    _loading = false;
                  });
                });
              });
            },
          ),
        ],
      ),
    );

    Widget payButton = Expanded(
      child: RaisedButton(
        color: Colors.redAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.account_balance_wallet,
              size: _iconSize,
              color: Colors.white,
            ),
            Text(
              "Pay",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentPage(title: "Payment")));
        },
      ),
    );

    Widget receiveButton = Expanded(
      child: RaisedButton(
        color: Colors.cyan,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_circle,
              size: _iconSize,
              color: Colors.white,
            ),
            Text(
              "Receive",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceivePage(title: "Receive Payment"),
            ),
          );
        },
      ),
    );

    Widget txOutButton = Expanded(
      child: RaisedButton(
        color: Colors.orange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.money_off,
              size: _iconSize,
              color: Colors.white,
            ),
            Text(
              "Sent",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
            Text(
              "Transactions",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TxOutPage(title: "Sent Transactions")));
        },
      ),
    );

    Widget txInButton = Expanded(
      child: RaisedButton(
        color: Colors.green,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.attach_money,
              size: _iconSize,
              color: Colors.white,
            ),
            Text(
              "Received",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
            Text(
              "Transactions",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TxInPage(title: "Received Transactions")));
        },
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          accountSection,
          balanceSection,
          Expanded(
            child: Row(
              children: <Widget>[
                payButton,
                receiveButton,
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                txOutButton,
                txInButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
