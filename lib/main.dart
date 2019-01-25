import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redbellywallet/rbbclib/account.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';
import 'package:redbellywallet/ui/homePage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

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
            if (server.contains(":")) {
              try {
                List<String> tuple = server.split(":");
                MyApp.servers.add(ServerTuple(tuple[0], int.parse(tuple[1])));
              } catch (e) {}
            }
          });
        }
        setState(() {
          _loading = false;
        });
//        var localAuth = LocalAuthentication();
//        while(true){
//          localAuth.authenticateWithBiometrics(
//              localizedReason: 'Please authenticate to show account balance',
//              useErrorDialogs: false).then((value){
//            if(value){
//              setState(() {
//                _loading = false;
//              });
//              return;
//            }
//          });
//        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Red Belly Blockchain Wallet',
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Color.fromARGB(255, 202, 54, 4),
          fontFamily: 'rbbc',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        home: _loading ? _loadingView : HomePage(title: "Red Belly Blockchain Wallet"),
    );
  }
}
