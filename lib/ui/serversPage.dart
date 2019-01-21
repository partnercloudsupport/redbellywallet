import 'dart:io';

import 'package:flutter/material.dart';
import 'package:redbellywallet/main.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';

import 'alertDialog.dart';

class ServersPage extends StatefulWidget {
  ServersPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  TextEditingController _host = TextEditingController();
  TextEditingController _port = TextEditingController();
  bool _buttonActive = true;

  @override
  void initState() {
    super.initState();
    _buttonActive = true;
    if(MyApp.servers.length > 0){
      ServerTuple server = MyApp.servers.first;
      _host.text = server.host;
      _port.text = server.port.toString();
    }
  }

  _addServer() {
    setState(() {
      _buttonActive = false;
    });

    int port = 0;

    try {
      port = int.parse(_port.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(
            title: "Error",
            content: "Wrong Port Format",
          );
        },
      );
      setState(() {
        _buttonActive = true;
      });
      return;
    }

    if (port < 0 || port > 65535) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(
            title: "Error",
            content: "Port Number Should be within 0 and 65535",
          );
        },
      );
      setState(() {
        _buttonActive = true;
      });
      return;
    }

    if (MyApp.servers.contains(ServerTuple(_host.text, port))) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(
            title: "Error",
            content: "Server Already Added",
          );
        },
      );
      setState(() {
        _buttonActive = true;
      });
      return;
    }

    Socket.connect(_host.text, port, timeout: Duration(seconds: 2)).then(
        (socket) {
      socket.close();
      MyApp.servers.add(ServerTuple(_host.text, port));
      String servers = "";
      MyApp.servers.forEach((s) {
        servers += s.toString() + " ";
      });
      MyApp.storage.write(key: "servers", value: servers).then((value) {
        setState(() {
          _buttonActive = true;
        });
      });
    }, onError: (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(
            title: "Error",
            content: "Invalid Server",
          );
        },
      );
      setState(() {
        _buttonActive = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget hostInput = TextFormField(
      controller: _host,
      style: TextStyle(
        color: Colors.black54,
        fontSize: 30,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.cloud_circle, size: 40),
        hintText: "Please enter server host address.",
        helperText: "Server host address",
        helperStyle: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
      ),
    );

    Widget portInput = TextFormField(
      controller: _port,
      style: TextStyle(
        color: Colors.black54,
        fontSize: 30,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.location_searching, size: 40),
        hintText: "Please enter server port number.",
        helperText: "Server port number",
        helperStyle: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
      ),
      keyboardType: TextInputType.number,
    );

    Widget inputSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                hostInput,
                portInput,
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_box),
            color: _buttonActive ? Colors.red : Colors.grey,
            onPressed: _buttonActive ? _addServer : null,
            iconSize: 40,
          )
        ],
      ),
    );

    List<ServerTuple> servers = MyApp.servers.toList();
    Widget serverList = Expanded(
        child: new ListView.builder(
            itemCount: MyApp.servers.length,
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
                    servers[index].toString(),
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
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                title: new Text('Delete'),
                                onTap: () {
                                  MyApp.servers.remove(servers[index]);
                                  String _servers = "";
                                  MyApp.servers.forEach((s) {
                                    _servers += s.toString() + " ";
                                  });
                                  MyApp.storage
                                      .write(key: "servers", value: _servers);
                                  setState(() {
                                    Navigator.pop(context);
                                  });
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
          inputSection,
          Container(
            height: 20,
          ),
          serverList,
        ],
      ),
    );
    ;
  }
}
