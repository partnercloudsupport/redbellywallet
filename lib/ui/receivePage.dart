import 'package:flutter/material.dart';

class ReceivePage extends StatefulWidget{
  ReceivePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReceivePageState createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  TextEditingController _receiver = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
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
                      controller: _receiver,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Please receiver's account address"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}