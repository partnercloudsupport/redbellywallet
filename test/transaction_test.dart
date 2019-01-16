import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:redbellywallet/rbbclib/account.dart';
import 'package:redbellywallet/rbbclib/transaction.dart';

txIn_serialize_test() {
  String expected =
      "AAAALwAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQID";
  var txIn = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  Uint8List byte_result = txIn.serialize();
//  print(byte_result);
  String result = Base64Encoder().convert(byte_result);
  print("TxIn: $result");
  test("TxIn Serialize", () {
    expect(result, expected);
  });
}

txIn_deserialize_test(){
  var txIn = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  Uint8List serializedTxIn = txIn.serialize();
  var desTxIn = TxIn.deserialize(serializedTxIn);
  print(txIn);
  print(desTxIn);
  print(txIn == desTxIn);
  test("TxIn Deserialize", (){
    expect(desTxIn, txIn);
  });
}

txIn_equal_test(){
  TxIn txIn1 = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  TxIn txIn2 = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  TxIn txIn3 = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 4])));
  test("TxIn equal(true)", (){
    expect(txIn1 == txIn2, true);
  });
  test("TxIn equal(false)", (){
    expect(txIn1 == txIn3, false);
  });
  test("TxIn Equal(Different type)", (){
    expect(txIn1 == Uint8List(2), false);
  });
}

txOut_serialize_test() {
  String expected = "AAAAEwAAAAAAAAAKAAAAAwECAwMEBAU=";
  var txOut = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  Uint8List byte_result = txOut.serialize();
//  print(byte_result);
  String result = Base64Encoder().convert(byte_result);
  print("TxOut: $result");
  test("TxOut Serialize", () {
    expect(result, expected);
  });
}

txOut_deserialize_test(){
  var txOut = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  Uint8List serializedTxOut = txOut.serialize();
  var desTxOut = TxOut.deserialize(serializedTxOut);
  print(txOut);
  print(desTxOut);
  test("TxOut Deserialize", () {
    expect(txOut, desTxOut);
  });
}

txOut_equal_test(){
  TxOut txOut1 = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  TxOut txOut2 = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  TxOut txOut3 = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 3,4,5])));
  test("TxOut Equal(true)", (){
    expect(txOut1 == txOut2, true);
  });
  test("TxOut Equal(false)", (){
    expect(txOut1 == txOut3, false);
  });
  test("TxOut Equal(Different type)", (){
    expect(txOut1 == Uint8List(2), false);
  });
}

tx_serialize_test() {
  String expected = "AAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMwAAAC8AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQECAwAAABcAAAATAAAAAAAAAAoAAAADAQIDAwQEBQ==";
  var txIn = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  var txOut = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  var tx = Transaction();
  tx.hash = Uint8List(32);
  tx.addTxIn(txIn);
  tx.addTxOut(txOut);
  Uint8List byte_result = tx.serialize();
  String result = Base64Encoder().convert(byte_result);
  print("Tx Serialize: $result");
  test("Tx Serialize",(){
    expect(result, expected);
  });
}

tx_deserialize_test() {
  var txIn = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  var txOut = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  var tx = Transaction();
  tx.hash = Uint8List(32);
  tx.addTxIn(txIn);
  tx.addTxOut(txOut);
  Uint8List serializedTx = tx.serialize();
  var desTx = Transaction.deserialize(serializedTx);
  print(desTx);
  test(("Tx Deserialize TxIn"), (){
    expect(desTx.txIns.length, 1);
    expect(desTx.txIns[0], txIn);
  });
  test(("Tx Deserialize TxOut"), (){
    expect(desTx.txOuts.length, 1);
    expect(desTx.txOuts[0], txOut);
  });
}

tx_hash_test(){
  String expected = "tpl1EpnrY45viRsrxfV3LRAvBXmZ4vfWMcLpw9mT0SI=";
  var txIn = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  var txOut = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  var tx = Transaction();
  tx.addTxIn(txIn);
  tx.addTxOut(txOut);
  Uint8List hash = tx.getHash();
  String result = Base64Encoder().convert(hash);
  print("Tx hash: $result");
  test("Tx hash",(){
    expect(result, expected);
  });
}

tx_sign_test(){
  String expected = "AAAARjBEAiAEyRud90Op7aik72K4+FSgxlNJ0Dk8iTqzcixlMGOmqQIgKXEAFJFMgNNqZdK8jl3iWsIRI+F5exL21gz2qJfKQ+AAAABBBHQs+WvcQ3POlhbPYKXhNack3zp2Qus0wKQ7eIn5lIFyzwlyffYL/ChRWH1z15XxUm1bwcwxmGJrz0IlCAuI7DkAAAAgtpl1EpnrY45viRsrxfV3LRAvBXmZ4vfWMcLpw9mT0SIAAAAzAAAALwAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQIDAAAAFwAAABMAAAAAAAAACgAAAAMBAgMDBAQF";
  var txIn = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  var txOut = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  var tx = Transaction();
  tx.addTxIn(txIn);
  tx.addTxOut(txOut);
  tx.getHash();
  String priKey = "7U/vulAIWsLIM3qf3FKCGGc9kniP3Ks26tLQcI7oJbc=";
  Account account = Account.fromPrivateKey(priKey);
  Uint8List byte_result = tx.signTx(account);
  String result = Base64Encoder().convert(byte_result);
  print("Signed Tx: $result");
  print("Expect Tx: $expected");
  test("Signed Tx",(){
    expect(result, expected);
  });
}

tx_deserialize_signed_test(){
  var txIn = TxIn(Uint8List(32), 1, Uint8List.fromList(List.from([1, 2, 3])));
  var txOut = TxOut(10, Uint8List.fromList(List.from([1, 2, 3])), Uint8List.fromList(List.from([3, 4,4,5])));
  var tx = Transaction();
  tx.addTxIn(txIn);
  tx.addTxOut(txOut);
  tx.getHash();
  String priKey = "7U/vulAIWsLIM3qf3FKCGGc9kniP3Ks26tLQcI7oJbc=";
  Account account = Account.fromPrivateKey(priKey);
  Uint8List signedTx = tx.signTx(account);
  Transaction desSignedTx = Transaction.deserializeSignedTx(signedTx);
  test("Deserialize Signed TxIn", (){
    expect(desSignedTx.txIns.length, 1);
    expect(desSignedTx.txIns[0], txIn);
  });
  test("Deserialize Signed TxOut", (){
    expect(desSignedTx.txOuts.length, 1);
    expect(desSignedTx.txOuts[0], txOut);
  });
  test("Deserialize Signed Hash", (){
    expect(base64Encode(desSignedTx.hash), base64Encode(tx.hash));
  });
}

bigEndian_test(){
  Uint8List buffer32 = BigEndian.encode32(1234);
  test("Test 32-bit encoding",(){
    expect(buffer32, Uint8List.fromList(List<int>.from([0,0,4,210])));
  });
  print(buffer32);
  test("Test 32-bit decoding",(){
    expect(BigEndian.decode32(buffer32), 1234);
  });
  print(BigEndian.decode32(buffer32));

  Uint8List buffer64 = BigEndian.encode64(12345678);
  test("Test 64-bit encoding",(){
    expect(buffer64, Uint8List.fromList(List<int>.from([0,0,0,0,0,188,97,78])));
  });
  print(buffer64);
  test("Test 64-bit decoding",(){
    expect(BigEndian.decode64(buffer64), 12345678);
  });
  print(BigEndian.decode64(buffer64));
}

main() {
//  txIn_serialize_test();
//  txIn_deserialize_test();
//  txIn_equal_test();
//  txOut_serialize_test();
//  txOut_deserialize_test();
//  txOut_equal_test();
//  tx_serialize_test();
//  tx_deserialize_test();
//  tx_hash_test();
  tx_sign_test();
//  tx_deserialize_signed_test();
//  bigEndian_test();
}
