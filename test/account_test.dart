import 'dart:convert';

import 'package:test/test.dart';
import 'package:bitcoin_flutter/src/ecpair.dart';
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';

import 'package:redbellywallet/rbbclib/account.dart';

String priKey = "7U/vulAIWsLIM3qf3FKCGGc9kniP3Ks26tLQcI7oJbc=";
String pubKey = "BHQs+WvcQ3POlhbPYKXhNack3zp2Qus0wKQ7eIn5lIFyzwlyffYL/ChRWH1z15XxUm1bwcwxmGJrz0IlCAuI7Dk=";
String addr = "1kppibUS0dYjib1STztsUK3I67A=";


main(){
  Account acc = Account.fromPrivateKey(priKey);

  test("Private key matches", (){
    expect(Base64Encoder().convert(acc.privateKey), priKey);
  });

  test("Public key matches", (){
    expect(Base64Encoder().convert(acc.publicKey), pubKey);
  });

  test("Address matches", (){
    expect(Base64Encoder().convert(acc.address), addr);
  });


  final keypair =
  ECPair.fromPrivateKey(Base64Decoder().convert(priKey), compressed: false);
  var private = Base64Encoder().convert(keypair.privateKey);
  var public = Base64Encoder().convert(keypair.publicKey);
  var address = Base64Encoder().convert(
      new P2PKH(data: new P2PKHData(pubkey: keypair.publicKey)).data.hash);
  print(address);
  print(addr);
  print("Address match: ${addr == address}\n");
  print(public);
  print(pubKey);
  print("Public Key match: ${pubKey == public}\n");
  print(private);
  print(priKey);
  print("Privite Key match: ${priKey == private}\n");

  print("-----------------------------------------------");

  private = Base64Encoder().convert(acc.privateKey);
  public = Base64Encoder().convert(acc.publicKey);
  address = Base64Encoder().convert(acc.address);

  print(address);
  print(addr);
  print("Address match: ${addr == address}\n");
  print(public);
  print(pubKey);
  print("Public Key match: ${pubKey == public}\n");
  print(private);
  print(priKey);
  print("Privite Key match: ${priKey == private}\n");
}