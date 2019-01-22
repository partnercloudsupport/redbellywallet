import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redbellywallet/main.dart';
import 'package:redbellywallet/rbbclib/account.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';

import 'alertDialog.dart';

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _visible = false;
  TextEditingController _privateKey = TextEditingController(
      text: MyApp.accounts.isEmpty
          ? ""
          : base64Encode(MyApp.client.account.privateKey));

  Color color = Colors.red;
  double iconSize = 35;

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
      if (MyApp.accounts.containsKey(base64Encode(account.address))) {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Account Already Added",
            );
          },
        );
        return;
      }
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
          return SimpleAlertDialog(
            title: "Error",
            content: "Wrong Key Format",
          );
        },
      );
    }
  }

  void _deleteAccount() {
    if (MyApp.client != null) {
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
      setState(() {});
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

    List<String> keys = MyApp.accounts.keys.toList();
    Widget accountList = Expanded(
        child: new ListView.builder(
            itemCount: MyApp.accounts.length,
            itemBuilder: (context, int index) {
              return GestureDetector(
                child: Container(
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  alignment: Alignment(-0.9, 1.0),
                  decoration: BoxDecoration(
                    border: new Border(
                      bottom: new BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Text(
                    keys[index],
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                                leading: new Icon(
                                  Icons.autorenew,
                                  color: Colors.red,
                                ),
                                title: new Text('Switch'),
                                onTap: () {
                                  MyApp.client.account = MyApp.accounts[keys[index]];
                                  MyApp.storage.write(
                                      key: "currentAccount",
                                      value: base64Encode(MyApp.client.account.privateKey));
                                  setState(() {
                                    _privateKey.text = base64Encode(MyApp.client.account.privateKey);
                                    Navigator.pop(context);
                                  });
                                }),
                            ListTile(
                                leading: new Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                title: new Text('Delete'),
                                onTap: () {
                                  if (base64Encode(
                                          MyApp.client.account.address) ==
                                      keys[index]) {
                                    _deleteAccount();
                                      Navigator.pop(context);
                                  } else {
                                    MyApp.accounts.remove(keys[index]);
                                    String accounts = "";
                                    MyApp.accounts.values.forEach((account) {
                                      accounts +=
                                          base64Encode(account.privateKey) +
                                              " ";
                                    });
                                    MyApp.storage
                                        .write(key: "accounts", value: accounts)
                                        .then((value) {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    });
                                  }
                                }),
                            ListTile(
                              leading: new Icon(
                                Icons.content_copy,
                                color: Colors.red,
                              ),
                              title: new Text('Copy'),
                              onTap: () {
                                Clipboard.setData(
                                    new ClipboardData(text: keys[index]));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
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
          Container(
            height: 20,
          ),
          accountList,
        ],
      ),
    );
  }
}
