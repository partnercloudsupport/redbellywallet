import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redbellywallet/main.dart';
import 'alertDialog.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _company = TextEditingController();
  TextEditingController _content = TextEditingController();

  List<String> _roles = [
    'Developer',
    'Investor',
    'Customer',
    'Partner',
    'Journalist'
  ];
  String _selectedRole = 'Please Choose a Role';

  @override
  Widget build(BuildContext context) {
    Widget _nameInput = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Name",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        TextFormField(
          controller: _name,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black54,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Please Enter Your Name",
            hintStyle: TextStyle(
              fontSize: 25,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );

    Widget _companyInput = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Company/University",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        TextFormField(
          controller: _company,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black54,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Please Enter Your Company/University",
            hintStyle: TextStyle(
              fontSize: 25,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );

    Widget _positionInput = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Role",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
            items: _roles.map((String val) {
              return new DropdownMenuItem<String>(
                value: val,
                child: new Text(
                  val,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black54,
                  ),
                ),
              );
            }).toList(),
            hint: Text(
              _selectedRole,
              style: TextStyle(
                fontSize: 25,
                color: Colors.black54,
              ),
            ),
            onChanged: (newVal) {
              _selectedRole = newVal;
              this.setState(() {});
            }),
      ],
    );

    Widget _contentInput = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Why are you interested in Red Belly Blockchain?",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        TextFormField(
          maxLines: 5,
          controller: _content,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black54,
          ),
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _nameInput,
          Container(
            height: 20,
          ),
          _companyInput,
          Container(
            height: 20,
          ),
          _positionInput,
          Container(
            height: 20,
          ),
          _contentInput,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _launchURL,
                color: Colors.red,
                child: Text(
                  "Send",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    if (_name.text == "") {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Name cannot be empty.",
            );
          });
      return;
    }

    if (_company.text == "") {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Company/University cannot be empty.",
            );
          });
      return;
    }

    if (_selectedRole == 'Please Choose a Role') {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Please pick a role",
            );
          });
      return;
    }

    if (_content.text == "") {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: "Error",
              content: "Content cannot be empty",
            );
          });
      return;
    }

    String url = 'mailto:csrg.sydney@gmail.com'
        '?subject=Coin Request From ${_name.text}'
        '&body=Address: ${base64Encode(MyApp.client.account.address)}\nCompany: ${_company.text}\nRole: ${_selectedRole}\nContent: ${_content.text}\n';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
