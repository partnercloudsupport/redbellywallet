import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbellywallet/main.dart';
import 'package:redbellywallet/rbbclib/account.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _visible = false;
  TextEditingController _privateKey = new TextEditingController(
      text: MyApp.accounts.isEmpty
          ? ""
          : base64Encode(MyApp.client.account.privateKey));

  void _changeVisibility() {
    setState(() {
      _visible = !_visible;
    });
  }

  void _createAccount() {
    Account account = Account.newAccount();
    setState(() {
      MyApp.client = RpcClient.fromAccount(account);
      MyApp.accounts[base64Encode(account.address)] = account;
      _privateKey.text = base64Encode(account.privateKey);
      MyApp.storage.write(
          key: "currentAccount",
          value: base64Encode(MyApp.client.account.privateKey));
      String accounts = "";
      MyApp.accounts.values.forEach((account) {
        accounts += base64Encode(account.privateKey) + " ";
      });
      MyApp.storage.write(key: "accounts", value: accounts);
    });
  }

  void _saveAccount() {
    try {
      String privateKey = _privateKey.text;
      Account account = Account.fromPrivateKey(privateKey);
      setState(() {
        MyApp.client = RpcClient.fromAccount(account);
        MyApp.accounts[base64Encode(account.address)] = account;
        MyApp.storage.write(
            key: "currentAccount",
            value: base64Encode(MyApp.client.account.privateKey));
        String accounts = "";
        MyApp.accounts.values.forEach((account) {
          accounts += base64Encode(account.privateKey) + " ";
        });
        MyApp.storage.write(key: "accounts", value: accounts);
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Wrong Private Key Format"),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("close")),
              ],
            );
          });
    }
  }

  void _deleteAccount() {
    if (MyApp.client != null) {
      setState(() {
        MyApp.accounts.remove(base64Encode(MyApp.client.account.address));
        if (MyApp.accounts.length > 0) {
          MyApp.client.setAccount(MyApp.accounts.values.first);
          _privateKey.text = base64Encode(MyApp.client.account.privateKey);
          MyApp.storage.write(
              key: "currentAccount",
              value: base64Encode(MyApp.client.account.privateKey));
          String accounts = "";
          MyApp.accounts.values.forEach((account) {
            accounts += base64Encode(account.privateKey) + " ";
          });
          MyApp.storage.write(key: "accounts", value: accounts);
        } else {
          MyApp.client = null;
          _privateKey.text = "";
          MyApp.storage.delete(key: "currentAccount");
          MyApp.storage.delete(key: "accounts");
        }
      });
    }
  }

  Column _buildButtonColumn(IconButton icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;
    double iconSize = 35;
    Widget keyInput = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Private Key',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _privateKey,
                  obscureText: (!_visible),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter your private key'),
                ),
              ],
            ),
          ),
          IconButton(
            icon: (_visible
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off)),
            color: color,
            onPressed: _changeVisibility,
            iconSize: iconSize,
          ),
        ],
      ),
    );

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              IconButton(
                  icon: Icon(Icons.add_circle),
                  iconSize: iconSize,
                  color: color,
                  onPressed: _createAccount),
              "NEW"),
          _buildButtonColumn(
              IconButton(
                  icon: Icon(Icons.save),
                  iconSize: iconSize,
                  color: color,
                  onPressed: _saveAccount),
              'SAVE'),
          _buildButtonColumn(
              IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: iconSize,
                  color: color,
                  onPressed: _deleteAccount),
              "DELETE"),
        ],
      ),
    );

    Widget accountList = Expanded(
        child: new ListView.builder(
            itemCount: MyApp.accounts.length,
            itemBuilder: (context, int index) {
              return GestureDetector(
                child: Text(
                  MyApp.accounts.keys.toList()[index],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Text(
                                    'This is the modal bottom sheet. Tap anywhere to dismiss.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 24.0))));
                      });
                },
              );
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          keyInput,
          buttonSection,
          accountList,
        ],
      ),
    );
  }
}
