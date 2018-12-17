import 'dart:typed_data';
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'transaction.dart';

@JsonSerializable(nullable: false)
class UtxoOutput{
  int value;
  bool spent;
  Uint8List script;
  Uint8List address;

  UtxoOutput(this.value, this.spent, this.script, this.address);

  @override
  String toString() {
    return "Value: $value\n"
        "Spent: $spent\n"
        "Script: ${Base64Encoder().convert(script)}\n"
        "Address: ${Base64Encoder().convert(address)}";
  }
}

@JsonSerializable(nullable: false)
class UtxoReturn{
  int value;
  int index;
  String hash;

  UtxoReturn(this.value, this.index, this.hash);

  @override
  String toString() {
    return "Value: $value\n"
        "Index: $index\n"
        "Hash: $hash";
  }
}

@JsonSerializable(nullable: false)
class UtxoTable{
  Map<String, List<UtxoOutput>> entries;
  Map<String, Map<String, int>> userTxTable;

  UtxoTable(){
    entries = new Map<String, List<UtxoOutput>>();
    userTxTable = new Map<String, Map<String, int>>();
  }

  // Add tx to UserTxTable
  addToUser(String address, String hash, int index){
    if(!userTxTable.containsKey(address)){
      userTxTable[address] = new Map<String, int>();
    }
    if(!userTxTable[address].containsKey(hash)){
      userTxTable[address][hash] = index;
    }
  }

  addUtxo(String hash, UtxoOutput utxo){
    if(!entries.containsKey(hash)){
      entries[hash] = new List<UtxoOutput>();
    }

    entries[hash].add(utxo);
  }

  // Add tx to utxo Entries
  addUtxoList(String hash, List<UtxoOutput> list){
    if(!entries.containsKey(hash)){
      entries[hash] = new List<UtxoOutput>();
    }

    entries[hash].addAll(list);
  }

  addOutputs(String hash, List<TxOut> outs){
    List<UtxoOutput> outputList = List();
    int index;
    for(var txOut in outs){
      outputList.add(UtxoOutput(txOut.value, false, txOut.script, txOut.address));
      this.addToUser(base64Encode(txOut.address), hash, index++);
    }
    this.addUtxoList(hash, outputList);
  }

  initializeFromBootstrap(Uint8List received){
    if(received == null){
      return;
    }
    var jsonData = jsonDecode(utf8.decode(received));
    jsonData.forEach((String key, var utxoList){
      utxoList.forEach((var utxo){
        this.addUtxo(key, UtxoOutput(utxo["Value"], utxo["Spent"], base64Decode(utxo["Script"]), base64Decode(utxo["Address"])));
      });
    });
    initializeUserTable();
  }
  
  initializeUserTable(){
    this.entries.forEach((String key, List<UtxoOutput> utxos){
      utxos.forEach((UtxoOutput utxo){
        if(utxo != null) addToUser(base64Encode(utxo.address), key, utxos.indexOf(utxo));
      });
    });
  }
  
  List<UtxoOutput> findForAccount(Uint8List address){
    List<UtxoOutput> outputs = List();
    String addr = base64Encode(address);
    if(userTxTable.containsKey(addr)){
      userTxTable[addr].forEach((String key, int index){
        outputs.add(entries[key][index]);
      });
    }
    return outputs;
  }
  
  UtxoOutput lookUpEntry(String hash, int id, Uint8List address){
    List<UtxoOutput> list = entries[hash];
    
    if(list == null || list.length < id){
      return null;
    }
    
    var utxo = list[id];
    if(utxo == null || base64Encode(utxo.address) != base64Encode(address)){
      return null;
    }

    return utxo;
  }
}

class UserUtxoTable {
  List<UtxoReturn> utxoReturns;
  List<UtxoOutput> utxoOutputs;

  UserUtxoTable(){
    utxoReturns = List();
    utxoOutputs = List();
  }

  setUtxoReturns(userUtxoReturns){
    if(userUtxoReturns == null) return;

    this.utxoReturns.clear();

    userUtxoReturns.forEach((var utxo){
      utxoReturns.add(UtxoReturn(utxo["Value"], utxo["Index"], utxo["Hash"]));
    });
  }

  setUtxoOutputs(userUtxoOutputs){
    if(userUtxoOutputs == null) return;

    this.utxoOutputs.clear();

    userUtxoOutputs.forEach((var utxo){
      utxoOutputs.add(UtxoOutput(utxo["Value"], utxo["Spent"], base64Decode(utxo["Script"]), base64Decode(utxo["Address"])));
    });
  }

  int getBalance(){
    int total = 0;

    this.utxoOutputs.forEach((UtxoOutput utxoOutput){
      if(utxoOutput != null && !utxoOutput.spent) total += utxoOutput.value;
    });

    return total;
  }
}