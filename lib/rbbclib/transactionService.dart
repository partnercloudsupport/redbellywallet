import 'dart:typed_data';

import 'package:hex/hex.dart';

import 'account.dart';
import 'transaction.dart';
import 'utxo.dart';

class TransactionService {
  UtxoTable utxoTable;

  TransactionService() {
    utxoTable = UtxoTable();
  }

  Uint8List makeSignedTransaction(
      List<TxIn> txIns, Uint8List receiver, Account sender, int value) {
    int total;

    txIns.forEach((TxIn txIn) {
      UtxoOutput utxoOut = utxoTable.lookUpEntry(
          String.fromCharCodes(txIn.hash), txIn.index, sender.address);
      if (utxoOut != null && !utxoOut.spent) {
        total += utxoOut.value;
      }
    });

    if (total < value) {
      return null;
    }

    List<TxOut> txOuts = List();
    txOuts.add(TxOut(value, sender.publicKey, receiver));
    txOuts.add(TxOut(total - value, sender.publicKey, sender.address));

    Transaction tx = Transaction();
    tx.txIns.addAll(txIns);
    tx.txOuts.addAll(txOuts);
    tx.getHash();

    return tx.signTx(sender);
  }
}

class UserTxService {
  UserUtxoTable userUtxoTable;
  Account account;

  UserTxService(this.account) {
    userUtxoTable = UserUtxoTable();
  }

  setUserUtxoReturns(userUtxoReturns) {
    this.userUtxoTable.setUtxoReturns(userUtxoReturns);
  }

  setUserUtxoOutputs(userUtxoOutputs) {
    this.userUtxoTable.setUtxoOutputs(userUtxoOutputs);
  }

  Uint8List makeSignedTransaction(Uint8List receiver, int value) {
    int total = userUtxoTable.getBalance();

    if (total < value || value <= 0) {
      return null;
    }

    List<TxIn> txIns = List();

    userUtxoTable.utxoReturns.forEach((utxoReturn) {
      txIns.add(TxIn(
          HEX.decode(utxoReturn.hash), utxoReturn.index, this.account.address));
    });

    List<TxOut> txOuts = List();
    txOuts.add(TxOut(value, this.account.publicKey, receiver));
    if (total - value > 0)
      txOuts.add(
          TxOut(total - value, this.account.publicKey, this.account.address));

    Transaction tx = Transaction();
    tx.txIns.addAll(txIns);
    tx.txOuts.addAll(txOuts);
    tx.getHash();

    return tx.signTx(this.account);
  }
}
