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
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Container(
            width: 100.0,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.red,
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
                      fontSize: 30,
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
                      fontSize: 25,
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
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Container(
            width: 100.0,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.monetization_on,
              size: 50,
              color: Colors.red,
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _loading ? "N/A" : _balance.toString(),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget payButton = Expanded(
      child: RaisedButton(
        color: Colors.redAccent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70.0,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.account_balance_wallet,
                size: 50,
                color: Colors.white,
              ),
            ),
            Text(
              "Pay",
              style: TextStyle(
                fontSize: 40,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70.0,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.add_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
            Text(
              "Receive",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReceivePage(title: "Receive Payment")));
        },
      ),
    );

    Widget txOutButton = Expanded(
      child: RaisedButton(
        color: Colors.orange,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70.0,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.money_off,
                size: 50,
                color: Colors.white,
              ),
            ),
            Text(
              "      Sent\nTransactions",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TxOutPage(title: "Sent Tranasctions")));
        },
      ),
    );

    Widget txInButton = Expanded(
      child: RaisedButton(
        color: Colors.green,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70.0,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.attach_money,
                size: 50,
                color: Colors.white,
              ),
            ),
            Text(
              "   Received\nTransactions",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TxInPage(title: "Received Tranasctions")));
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
