import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redbellywallet/rbbclib/account.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';
import 'package:redbellywallet/ui/homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // Map<Base64-encoded Address, Account>
  static Map<String, Account> accounts = Map();

  // 70CuK4/E5OMpVWs3dyb3TiRccTW6dS2BExmYUKLtcc4=
  static RpcClient client;

  static HashSet<ServerTuple> servers = HashSet();

  static final storage = new FlutterSecureStorage();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    MyApp.storage.readAll().then((value) {
      setState(() {
        if (value.containsKey("currentAccount")) {
          MyApp.client = RpcClient.fromAccount(
              Account.fromPrivateKey(value["currentAccount"]));
        }
        if (value.containsKey("accounts")) {
          List<String> pks = value["accounts"].split(" ");
          pks.forEach((pk) {
            try {
              Account acc = Account.fromPrivateKey(pk);
              MyApp.accounts[base64Encode(acc.address)] = acc;
            } catch (e) {}
          });
        }
        if (value.containsKey("servers")) {
          List<String> servers = value["servers"].split(" ");
          servers.forEach((server) {
            try {
              List<String> tuple = server.split(":");
              MyApp.servers.add(ServerTuple(tuple[0], int.parse(tuple[1])));
            } catch (e) {}
          });
        }
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MyApp.servers.add(ServerTuple("129.78.10.53", 7822));
    MyApp.servers.add(ServerTuple("129.78.10.53", 7722));
    MyApp.servers.add(ServerTuple("129.78.10.53", 7522));
    return MaterialApp(
      title: 'Red Belly Blockchain Wallet',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: _loading
          ? _loadingView
          : HomePage(title: 'Red Belly Blockchain Wallet'),
    );
  }
}
