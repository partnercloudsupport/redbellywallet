import 'package:flutter/material.dart';

import 'accountSettingsPage.dart';
import 'serversPage.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(20),
            leading: Icon(
              Icons.account_circle,
              color: Colors.red,
              size: 40,
            ),
            title: Text(
              "Account",
              style: TextStyle(fontSize: 30),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AccountSettingsPage(title: "Account Settings")));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(20),
            leading: Icon(
              Icons.cloud,
              color: Colors.red,
              size: 40,
            ),
            title: Text(
              "Servers",
              style: TextStyle(fontSize: 30),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ServersPage(title: "Server Settings")));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(20),
            leading: Icon(
              Icons.security,
              color: Colors.red,
              size: 40,
            ),
            title: Text(
              "Security",
              style: TextStyle(fontSize: 30),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(20),
            leading: Icon(
              Icons.mail,
              color: Colors.red,
              size: 40,
            ),
            title: Text(
              "Contact",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}
