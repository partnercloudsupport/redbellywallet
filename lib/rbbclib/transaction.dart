import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import "package:pointycastle/pointycastle.dart";
import 'package:bip32/src/utils/ecurve.dart' as ecc;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';

import 'account.dart';

@JsonSerializable(nullable: false)
class TxIn {
  Uint8List hash;
  int index;
  Uint8List script;

  TxIn(this.hash, this.index, this.script);

  Uint8List serialize() {
    Uint8List hashLen = BigEndian.encode32(this.hash.length);
    Uint8List indexBytes = BigEndian.encode64(this.index);

    List<int> result = List.from(BigEndian.encode32(this.hash.length +
        hashLen.length +
        indexBytes.length +
        this.script.length));
    result.addAll(hashLen);
    result.addAll(this.hash.reversed);
    result.addAll(indexBytes);
    result.addAll(this.script);

    return Uint8List.fromList(result);
  }

  static TxIn deserialize(Uint8List serializedTxIn) {
    int len = serializedTxIn.length;
    int currentIndex = 0;

    if (len < 4) return null;
    List<int> buffer = serializedTxIn.sublist(0, 4);
    int totalLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < 4 + totalLen) return null;

    if (len < currentIndex + 4) return null;
    buffer = serializedTxIn.sublist(currentIndex, currentIndex + 4);
    int hashLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < currentIndex + hashLen) return null;
    Uint8List hash =
        serializedTxIn.sublist(currentIndex, currentIndex + hashLen);
    currentIndex += hashLen;

    if (len < currentIndex + 8) return null;
    buffer = serializedTxIn.sublist(currentIndex, currentIndex + 8);
    int index = BigEndian.decode64(buffer);
    currentIndex += 8;

    Uint8List script = serializedTxIn.sublist(currentIndex);

    return TxIn(hash, index, script);
  }

  static List<TxIn> deserializeTxIns(Uint8List serializedTxIns) {
    List<TxIn> txIns = List();
    int len = 0;
    int txInLen = 0;
    Uint8List buffer;

    while ((len = serializedTxIns.length) > 0) {
      if (len < 4) return null;
      buffer = serializedTxIns.sublist(0, 4);
      txInLen = BigEndian.decode32(buffer);

      if (len < 4 + txInLen) return null;
      TxIn txIn = deserialize(serializedTxIns.sublist(0, 4 + txInLen));

      if (txIn == null) return null;
      txIns.add(txIn);

      serializedTxIns = serializedTxIns.sublist(4 + txInLen);
    }
    return txIns;
  }

  @override
  String toString() {
    return "TxIn: {Hash: ${this.hash} Script: ${this.script} Index: ${this.index}}";
  }

  @override
  bool operator ==(dynamic other) {
    if (this.runtimeType != other.runtimeType) return false;
    bool i = this.index == other.index;
    bool s = base64Encode(this.script) == base64Encode(other.script);
    bool h = base64Encode(this.hash) == base64Encode(other.hash);
    return (i && s && h);
  }
}

@JsonSerializable(nullable: false)
class TxOut {
  int value;
  Uint8List script;
  Uint8List address;

  TxOut(this.value, this.script, this.address);

  Uint8List serialize() {
    Uint8List value = BigEndian.encode64(this.value);
    Uint8List scriptLen = BigEndian.encode32(this.script.length);

    List<int> result = List.from(BigEndian.encode32(value.length +
        scriptLen.length +
        this.script.length +
        this.address.length));
    result.addAll(value);
    result.addAll(scriptLen);
    result.addAll(this.script);
    result.addAll(this.address);

    return Uint8List.fromList(result);
  }

  static TxOut deserialize(Uint8List serializedTxOut) {
    int len = serializedTxOut.length;
    int currentIndex = 0;

    if (len < 4) return null;

    Uint8List buffer = serializedTxOut.sublist(0, 4);
    int totalLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < 4 + totalLen) return null;

    if (len < currentIndex + 8) return null;

    buffer = serializedTxOut.sublist(currentIndex, currentIndex + 8);
    int value = BigEndian.decode64(buffer);
    currentIndex += 8;

    if (value < 0) return null;

    if (len < currentIndex + 4) return null;

    buffer = serializedTxOut.sublist(currentIndex, currentIndex + 4);
    int scriptLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < currentIndex + scriptLen) return null;

    Uint8List script =
        serializedTxOut.sublist(currentIndex, currentIndex + scriptLen);
    currentIndex += scriptLen;

    Uint8List address = serializedTxOut.sublist(currentIndex);

    return new TxOut(value, script, address);
  }

  static List<TxOut> deserializeTxOuts(Uint8List serializedTxOuts) {
    List<TxOut> txOuts = List();
    int len = 0;
    int txOutLen = 0;
    Uint8List buffer;

    while ((len = serializedTxOuts.length) > 0) {
      if (len < 4) return null;
      buffer = serializedTxOuts.sublist(0, 4);
      txOutLen = BigEndian.decode32(buffer);

      if (len < 4 + txOutLen) return null;
      TxOut txOut = deserialize(serializedTxOuts.sublist(0, 4 + txOutLen));

      if (txOut == null) return null;
      txOuts.add(txOut);

      serializedTxOuts = serializedTxOuts.sublist(4 + txOutLen);
    }
    return txOuts;
  }

  @override
  String toString() {
    return "TxOut: {Value: ${this.value} Script: ${this.script} Address: ${this.address}}";
  }

  @override
  bool operator ==(dynamic other) {
    if (this.runtimeType != other.runtimeType) return false;
    bool v = this.value == other.value;
    bool a = base64Encode(this.address) == base64Encode(other.address);
    bool s = base64Encode(this.script) == base64Encode(other.script);
    return (v && a && s);
  }
}

@JsonSerializable(nullable: false)
class Transaction {
  List<TxIn> txIns;
  List<TxOut> txOuts;
  Uint8List hash;
  Uint8List fromAddress;

  Transaction() {
    txIns = List();
    txOuts = List();
  }

  factory Transaction.fromTx(List<TxIn> txIns, List<TxOut> txOuts) {
    Transaction tx = Transaction();
    tx.txIns = txIns;
    tx.txOuts = txOuts;
    return tx;
  }

  addTxIn(TxIn txIn) {
    this.txIns.add(txIn);
  }

  addTxOut(TxOut txOut) {
    this.txOuts.add(txOut);
  }

  Uint8List serialize() {
    List<int> ins = List();
    for (var txIn in txIns) {
      ins.addAll(txIn.serialize());
    }
    Uint8List insLen = BigEndian.encode32(ins.length);

    List<int> outs = List();
    for (var txOut in txOuts) {
      outs.addAll(txOut.serialize());
    }
    Uint8List outsLen = BigEndian.encode32(outs.length);

    Uint8List hashLen = BigEndian.encode32(this.hash.length);

    List<int> result = List();
    result.addAll(hashLen);
    result.addAll(this.hash);
    result.addAll(insLen);
    result.addAll(ins);
    result.addAll(outsLen);
    result.addAll(outs);

    return Uint8List.fromList(result);
  }

  static Transaction deserialize(Uint8List serializedTx) {
    int len = serializedTx.length;
    int currentIndex = 0;

    if (len < 4) return null;
    List<int> buffer = serializedTx.sublist(0, 4);
    int hashLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < currentIndex + hashLen) return null;
    Uint8List hash = serializedTx.sublist(currentIndex, currentIndex + hashLen);
    currentIndex += hashLen;

    if (len < currentIndex + 4) return null;
    buffer = serializedTx.sublist(currentIndex, currentIndex + 4);
    int insLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < currentIndex + insLen) return null;
    Uint8List serializedTxIns =
        serializedTx.sublist(currentIndex, currentIndex + insLen);
    currentIndex += insLen;

    List<TxIn> txIns = TxIn.deserializeTxIns(serializedTxIns);
    if (txIns == null) return null;

    if (len < currentIndex + 4) return null;
    buffer = serializedTx.sublist(currentIndex, currentIndex + 4);
    int outsLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < currentIndex + outsLen) return null;
    Uint8List serializedTxOuts =
        serializedTx.sublist(currentIndex, currentIndex + outsLen);

    List<TxOut> txOuts = TxOut.deserializeTxOuts(serializedTxOuts);
    if (txOuts == null) return null;

    return Transaction.fromTx(txIns, txOuts);
  }

  Uint8List signTx(Account account) {
    Uint8List serialized_tx = this.serialize();

    ECSignature sig = ecc.deterministicGenerateK(this.hash, account.privateKey);
    BigInt r = sig.r;
    BigInt s = sig.s;
    if (s > ecc.nDiv2) {
      s = ecc.n - s;
    }

    Uint8List rb = encodeBigInt(r);
    Uint8List sb = encodeBigInt(s);
    int len = 6 + rb.length + sb.length;
    Uint8List sigs = new Uint8List(len);
    sigs[0] = 0x30;
    sigs[1] = len - 2;
    sigs[2] = 0x02;
    sigs[3] = rb.length;
    sigs.setRange(4, 4 + rb.length, rb);
    sigs[4 + rb.length] = 0x02;
    sigs[5 + rb.length] = sb.length;
    sigs.setRange(6 + rb.length, len, sb);

    Uint8List sigsLen = BigEndian.encode32(sigs.length);
    Uint8List pubKeyLen = BigEndian.encode32(account.publicKey.length);

    List<int> result = List();
    result.addAll(sigsLen);
    result.addAll(sigs);
    result.addAll(pubKeyLen);
    result.addAll(account.publicKey);
    result.addAll(serialized_tx);

    return Uint8List.fromList(result);
  }

  static Transaction deserializeSignedTx(Uint8List signedTx) {
    int len = signedTx.length;
    int currentIndex = 0;

    if (len < 4) return null;

    List<int> buffer = signedTx.sublist(0, 4);
    int sigLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < currentIndex + sigLen) return null;

    Uint8List sigser = signedTx.sublist(currentIndex, sigLen + currentIndex);
    currentIndex += sigLen;

    if (len < currentIndex + 4) return null;

    buffer = signedTx.sublist(currentIndex, currentIndex + 4);
    int pubLen = BigEndian.decode32(buffer);
    currentIndex += 4;

    if (len < currentIndex + pubLen) return null;

    Uint8List publicKey = signedTx.sublist(currentIndex, currentIndex + pubLen);
    currentIndex += pubLen;

    Uint8List serializedTx = signedTx.sublist(currentIndex);
    Transaction tx = deserialize(serializedTx);

    tx.fromAddress = new P2PKH(data: new P2PKHData(pubkey: publicKey)).data.hash;
    tx.getHash();

    return tx;
  }

  Uint8List getHash() {
    List<int> ins = List();
    for (var txIn in txIns) {
      ins.addAll(txIn.serialize());
    }
    Uint8List insLen = BigEndian.encode32(ins.length);

    List<int> outs = List();
    for (var txOut in txOuts) {
      outs.addAll(txOut.serialize());
    }
    Uint8List outsLen = BigEndian.encode32(outs.length);

    List<int> serializeTx = List();
    serializeTx.addAll(insLen);
    serializeTx.addAll(ins);
    serializeTx.addAll(outsLen);
    serializeTx.addAll(outs);

    this.hash = sha256.convert(sha256.convert(serializeTx).bytes).bytes;

    return this.hash;
  }

  /// Encode a BigInt into bytes using big-endian encoding.
  Uint8List encodeBigInt(BigInt number) {
    var _byteMask = new BigInt.from(0xff);
    // Not handling negative numbers. Decide how you want to do that.
    int size = (number.bitLength + 7) >> 3;
    var result = new Uint8List(size);
    for (int i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      number = number >> 8;
    }
    return result;
  }

  /// Decode a BigInt from bytes using big-endian encoding.
  BigInt decodeBigInt(List<int> bytes) {
    BigInt result = new BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += new BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  @override
  String toString() {
    return "Transaction\nHash: ${this.hash}\nTxIns: ${this.txIns}\nTxOuts: ${this.txOuts}\n";
  }
}

class BigEndian {
  static Uint8List encode32(int v) {
    Uint8List b = new Uint8List(4);
    b[0] = v >> 24;
    b[1] = v >> 16;
    b[2] = v >> 8;
    b[3] = v;
    return b;
  }

  static int decode32(Uint8List b) {
    return b[3].toInt() |
        (b[2] << 8).toInt() |
        (b[1] << 16).toInt() |
        (b[0] << 24).toInt();
  }

  static Uint8List encode64(int v) {
    Uint8List b = new Uint8List(8);
    b[0] = v >> 56;
    b[1] = v >> 48;
    b[2] = v >> 40;
    b[3] = v >> 32;
    b[4] = v >> 24;
    b[5] = v >> 16;
    b[6] = v >> 8;
    b[7] = v;
    return b;
  }

  static int decode64(Uint8List b) {
    return b[7].toInt() |
        (b[6] << 8).toInt() |
        (b[5] << 16).toInt() |
        (b[4] << 24).toInt() |
        (b[3] << 32).toInt() |
        (b[2] << 40).toInt() |
        (b[1] << 48).toInt() |
        (b[0] << 56).toInt();
  }
}
