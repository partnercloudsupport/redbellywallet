import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbellywallet/main.dart';
import 'package:redbellywallet/rbbclib/account.dart';

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
          : Base64Encoder().convert(MyApp.account.privateKey));

  void _changeVisibility() {
    setState(() {
      _visible = !_visible;
    });
  }

  void _createAccount() {
    Account account = Account.newAccount();
    setState(() {
      MyApp.account = account;
      MyApp.accounts[Base64Encoder().convert(account.privateKey)] = account;
      _privateKey.text = Base64Encoder().convert(MyApp.account.privateKey);
    });
  }

  void _saveAccount() {
    try {
      String privateKey = _privateKey.text;
      Account account = Account.fromPrivateKey(privateKey);
      setState(() {
        MyApp.account = account;
        MyApp.accounts[privateKey] = account;
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
    if(MyApp.account != null){
      setState(() {
        MyApp.accounts.remove(base64Encode(MyApp.account.privateKey));
        if(MyApp.accounts.length > 0){
          MyApp.account = MyApp.accounts.values.first;
          _privateKey.text = Base64Encoder().convert(MyApp.account.privateKey);
        }else{
          MyApp.account = null;
          _privateKey.text = "";
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
    Color color = Colors.red[500];
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
              return Text(Base64Encoder()
                  .convert((MyApp.accounts.values.toList())[index].privateKey));
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
