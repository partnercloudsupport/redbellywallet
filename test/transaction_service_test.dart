import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:redbellywallet/rbbclib/account.dart';
import 'package:redbellywallet/rbbclib/transaction.dart';
import 'package:redbellywallet/rbbclib/transactionService.dart';

String utxoReturns = '[{"Hash":"77794ec182ea18702d19dc4f0ac7a09812bb5d31d03bb7ba65749821c8a763c5","Index":1,"Value":125}]';
String utxoOutputs = '[{"Value":125,"Spent":false,"Script":"BMNNCeTPThB7eV2EE6xtkb3MAk2UM/JfpTKiIUEuxGishmGAFwzWq3QEp9IcXzJXpXBYx5iyhfRCKN06Gh+vfN4=","Address":"WD9GS1AgzIuWfk3C+apwbmnangw="}]';

Account sender = Account.fromPrivateKey("70CuK4/E5OMpVWs3dyb3TiRccTW6dS2BExmYUKLtcc4=");
Account receiver = Account.fromPrivateKey("UuD3gwBYQ9K6qN1O5Y3eiyL3PsBh/2RBGy2PnN6rkFs=");

userTxService_makeSignedTransaction_test(){
  String expected = "AAAARjBEAiAv2p3NBffpp/dOVMdaxnXIeVzWl8hUo4sYQLPpGd76FwIgC4VZpOoj83FddG8KbhlSBN1cPswFWkaGQKtpWMORir0AAABBBMNNCeTPThB7eV2EE6xtkb3MAk2UM/JfpTKiIUEuxGishmGAFwzWq3QEp9IcXzJXpXBYx5iyhfRCKN06Gh+vfN4AAAAg9sl0Tm+Pwr7bgvYsCkS6whlZX47hPJXX0ue6j0h1QqoAAABEAAAAQAAAACDFY6fIIZh0Zbq3O9AxXbsSmKDHCk/cGS1wGOqCwU55dwAAAAAAAAABWD9GS1AgzIuWfk3C+apwbmnangwAAADKAAAAYQAAAAAAAAAKAAAAQQTDTQnkz04Qe3ldhBOsbZG9zAJNlDPyX6UyoiFBLsRorIZhgBcM1qt0BKfSHF8yV6VwWMeYsoX0QijdOhofr3ze3emMi4oJ0t0Cekm0vPytb4dUijcAAABhAAAAAAAAAHMAAABBBMNNCeTPThB7eV2EE6xtkb3MAk2UM/JfpTKiIUEuxGishmGAFwzWq3QEp9IcXzJXpXBYx5iyhfRCKN06Gh+vfN5YP0ZLUCDMi5Z+TcL5qnBuadqeDA==";
  UserTxService userTxService = UserTxService(sender);
  userTxService.userUtxoTable.setUtxoReturns(jsonDecode(utxoReturns));
  userTxService.userUtxoTable.setUtxoOutputs(jsonDecode(utxoOutputs));
  Uint8List signedTx = userTxService.makeSignedTransaction(receiver.address, 10);
  print(base64Encode(signedTx));
  print(expected);
  print(Transaction.deserializeSignedTx(signedTx));
  test("UserTxService MakeSignedTransaction", (){
    expect(base64Encode(signedTx), expected);
  });
}

main(){
  userTxService_makeSignedTransaction_test();
}
