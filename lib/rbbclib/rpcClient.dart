import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:collection';

import 'package:quiver/core.dart';

import 'account.dart';
import 'transaction.dart';
import 'transactionService.dart';

class RpcClient {
  HashSet<ServerTuple> servers;
  Account account;
  UserTxService userTxService;

  RpcClient(this.account) {
    this.servers = HashSet();
    this.userTxService = UserTxService(this.account);
  }

  factory RpcClient.newAccount() {
    return RpcClient(Account.newAccount());
  }

  factory RpcClient.fromAccount(Account account) {
    return RpcClient(account);
  }

  addServer(String host, int port) {
    servers.add(ServerTuple(host, port));
  }

  initUtxo() async {
    var userUtxoReturns = await this.getAccountUtxoReturns();
    userTxService.setUserUtxoReturns(userUtxoReturns);
    var userUtxoOutputs = await this.getAccountUtxoOutputs();
    userTxService.setUserUtxoOutputs(userUtxoOutputs);
  }

  int getBalance() {
    int balance = 0;

    this.userTxService.userUtxoTable.utxoReturns.forEach((utxo) {
      if (utxo != null) balance += utxo.value;
    });

    return balance;
  }

  Future<dynamic> getBootstrapTable() async {
    return Future.sync(() async {
      String request = json.encode({
        "method": "RpcNode.BootstrapTable",
        "params": [this.account.address.toList()],
        "id": "0",
      });
      String result = getConcensusResult(await safeCall(request));
      return jsonDecode(utf8.decode(base64Decode(result)));
    });
  }

  Future<dynamic> getAccountUtxoReturns() async {
    return Future.sync(() async {
      String request = json.encode({
        "method": "RpcNode.GetTableAccount",
        "params": [this.account.address.toList()],
        "id": "0",
      });
      String result = getConcensusResult(await safeCall(request));
      return jsonDecode(utf8.decode(base64Decode(result)));
    });
  }

  Future<dynamic> getAccountUtxoOutputs() async {
    return Future.sync(() async {
      String request = json.encode({
        "method": "RpcNode.FindForAccount",
        "params": [this.account.address.toList()],
        "id": "0",
      });
      String result = getConcensusResult(await safeCall(request));
      return jsonDecode(utf8.decode(base64Decode(result)));
    });
  }

  Future<List<TxOut>> getAccountTxOut() async {
    return Future.sync(() async {
      String request = json.encode({
        "method": "RpcNode.GetTxForAccount",
        "params": [this.account.address.toList()],
        "id": "0",
      });
      String result = getConcensusResult(await safeCall(request));
      List transactions = jsonDecode(utf8.decode(base64Decode(result)));
      List<TxOut> txOuts = new List();
      transactions.forEach((serializedTx){
        Transaction tx = Transaction.deserializeSignedTx(base64Decode(serializedTx));
        if(tx != null){
          tx.txOuts.forEach((txOut){
            if(base64Encode(txOut.address)!=base64Encode(this.account.address)){
              txOuts.add(txOut);
            }
          });
        }
      });
      return txOuts;
    });
  }

  Future<List<IncomingTxTuple>> getAccountIncomingTx() async {
    return Future.sync(() async {
      String request = json.encode({
        "method": "RpcNode.GetReceiveTxForAccount",
        "params": [this.account.address.toList()],
        "id": "0",
      });
      String result = getConcensusResult(await safeCall(request));
      List transactions = jsonDecode(utf8.decode(base64Decode(result)));
      List<IncomingTxTuple> incomingTxs = List();
      transactions.forEach((serializedTx){
        Transaction tx = Transaction.deserializeSignedTx(base64Decode(serializedTx));
        if(tx!=null){
          tx.txOuts.forEach((txOut){
            if(base64Encode(txOut.address) == base64Encode(account.address)){
              incomingTxs.add(IncomingTxTuple(base64Encode(tx.fromAddress), txOut.value));
            }
          });
        }
      });
      return incomingTxs;
    });
  }

  Future<bool> proposeTransaction(Uint8List receiver, int value) async {
    return Future.sync(() async {
      if(servers.length == 0){
        return false;
      }

      Uint8List signedTx = userTxService.makeSignedTransaction(receiver, value);

      if(signedTx == null) return false;

      String request = json.encode({
        "method": "RpcNode.ProposeTransaction",
        "params": [signedTx.toList()],
        "id": "0",
      });

      Map results = await safeCall(request);

      return results.containsKey("true");
    });
  }

  Future<Map> safeCall(String request) async {
    return Future.sync(() async {
      if (servers.length == 0) {
        return null;
      }

      Map<String, int> results = Map();
      List<Future<String>> threads = List();
      int server_num = 2 * (servers.length / 3).floor() + 1;

      for (int i = 0; i < server_num; i++) {
        threads.add(call(request, servers.elementAt(i), false));
      }

      for (Future<String> t in threads) {
        String data = await t;
        if (results.containsKey(data)) {
          results[data]++;
        } else {
          results[data] = 1;
        }
      }
      return results;
    });
  }

  Future<String> call(String request, ServerTuple server, bool tls) async {
    List<int> reply = List();
    Socket socket;
    if (tls) {
      socket = await SecureSocket.connect(server.host, server.port,
          onBadCertificate: (X509Certificate c) {
        print("Certificate WARNING: ${c.issuer}:${c.subject}");
        return true;
      });
    } else {
      socket = await Socket.connect(server.host, server.port);
    }
    String response;
    socket.listen((data) {
      reply.addAll(data);
//      print("Received: " + utf8.decode(data));
      int size = reply.length - 1;
      if (reply[size] == 10) {
        response = utf8.decode(reply.sublist(0, size));
        socket.close();
      }
    });
    socket.write(request);
    return socket.done.then((_) {
      var jsonResponse = json.decode(response);
      return jsonResponse["result"].toString();
    });
  }

  String getConcensusResult(Map<String, int> results){
    String result;
    int maxOcc = 0;
    results.forEach((String value, int occ) {
      if (occ > maxOcc) {
        maxOcc = occ;
        result = value;
      }
    });

    return result;
  }
}

class IncomingTxTuple{
  String sender;
  int value;

  IncomingTxTuple(this.sender, this.value);

  @override
  String toString() {
    return "Sender: $sender Value: $value";
  }
}

class ServerTuple {
  String host;
  int port;

  ServerTuple(this.host, this.port);

  @override
  bool operator ==(dynamic other) => other is ServerTuple && this.host == other.host && this.port == other.port;

  @override
  int get hashCode => hash2(host.hashCode, port.hashCode);

  @override
  String toString() {
    return "$host:$port";
  }
}
