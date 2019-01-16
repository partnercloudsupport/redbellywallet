import 'package:flutter/material.dart';

import 'accountSettingsPage.dart';

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
            leading: Icon(Icons.account_circle),
            title: Text("Account"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSettingsPage(title: "Account Settings")));
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud),
            title: Text("Servers"),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text("Security"),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("Contact"),
          ),
        ],
      ),
    );
  }
}
