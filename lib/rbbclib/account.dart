import 'dart:convert';
import 'dart:typed_data';

import 'package:bitcoin_flutter/src/ecpair.dart';
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';

class Account{
  Uint8List privateKey;
  Uint8List publicKey;
  Uint8List address;
  ECPair key;

  Account(this.key){
    this.privateKey = this.key.privateKey;
    this.publicKey = this.key.publicKey;
    this.address = new P2PKH(data: new P2PKHData(pubkey: this.key.publicKey)).data.hash;
  }

  factory Account.newAccount(){
    final ECPair keypair = ECPair.makeRandom(compressed: false);
    return new Account(keypair);
  }

  factory Account.fromPrivateKey(String priKey){
    final ECPair keypair = ECPair.fromPrivateKey(Base64Decoder().convert(priKey), compressed: false);
    return new Account(keypair);
  }
}