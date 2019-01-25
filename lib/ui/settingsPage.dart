import 'package:flutter/material.dart';

import 'accountSettingsPage.dart';
import 'serversPage.dart';
import 'contactPage.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _fontSize = 22.0;
  Color _color = Color.fromARGB(255, 202, 54, 4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: Icon(
              Icons.account_circle,
              color: _color,
              size: 40,
            ),
            title: Text(
              "Account",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AccountSettingsPage(title: "Account Settings"),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: Icon(
              Icons.cloud,
              color: _color,
              size: 40,
            ),
            title: Text(
              "Servers",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServersPage(title: "Server Settings"),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: Icon(
              Icons.security,
              color: _color,
              size: 40,
            ),
            title: Text(
              "Security",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: Icon(
              Icons.mail,
              color: _color,
              size: 40,
            ),
            title: Text(
              "Contact",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactPage(title: "Contact Us"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
