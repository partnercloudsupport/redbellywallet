import 'dart:convert';
import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redbellywallet/main.dart';

import 'alertDialog.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController _receiver = TextEditingController();
  TextEditingController _amount = TextEditingController();
  Color _color = Color.fromARGB(255, 202, 54, 4);
  double _iconSize = 50;
  double _fontSize = 20;

  Column _buildButtonColumn(IconButton icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Container(
          child: Text(
            label,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _pay() {
    String receiver = _receiver.text;
    int value = 0;

    try {
      value = int.parse(_amount.text);
      if (value <= 0) {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleAlertDialog(
                title: "Error",
                content: "Amount must be positive integer.",
              );
            });
        return;
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Wrong Amount Number Format",
            );
          });
      return;
    }

    if (MyApp.client == null) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Add Account First",
            );
          });
      return;
    }

    if (MyApp.servers.length == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Add Server First",
            );
          });
      return;
    }

    try {
      MyApp.client.servers = MyApp.servers;
      MyApp.client
          .proposeTransaction(base64Decode(receiver), value)
          .then((success) {
        if (success) {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleAlertDialog(
                  title: "Success",
                  content: "Transaction Successful",
                );
              });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleAlertDialog(
                title: "Error",
                content: "Trnsaction Failed",
              );
            },
          );
        }
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(
            title: "Error",
            content: "Wrong Receiver Address Format",
          );
        },
      );
    }
  }

  Future _scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this._receiver.text = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: 'No Camera Permission',
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: '$e',
            );
          },
        );
      }
    } on FormatException {} catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(
            title: "Error",
            content: '$e',
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget receiverInput = TextFormField(
      controller: _receiver,
      style: TextStyle(
        color: Colors.black54,
        fontSize: _fontSize,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          Icons.person,
          size: 40,
        ),
        hintText: "Receiver's Address",
      ),
    );

    Widget amountInput = TextFormField(
      controller: _amount,
      style: TextStyle(
        color: Colors.black54,
        fontSize: _fontSize,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          Icons.monetization_on,
          size: 40,
        ),
        hintText: "Payment Amount",
      ),
      keyboardType: TextInputType.number,
    );

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              IconButton(
                  icon: Icon(Icons.payment),
                  iconSize: _iconSize,
                  color: _color,
                  onPressed: _pay),
              "Pay"),
          _buildButtonColumn(
              IconButton(
                icon: Icon(Icons.camera_alt),
                iconSize: _iconSize,
                color: _color,
                onPressed: _scan,
              ),
              'Scan'),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                receiverInput,
                Container(
                  height: 20,
                ),
                amountInput,
                Container(
                  height: 20,
                ),
                buttonSection,
              ],
            ),
          ),
        ));
  }
}
