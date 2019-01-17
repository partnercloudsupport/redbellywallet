import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbellywallet/rbbclib/account.dart';
import 'package:redbellywallet/rbbclib/rpcClient.dart';
import 'package:redbellywallet/ui/homePage.dart';
import 'package:redbellywallet/ui/accountSettingsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Map<Base64-encoded Address, Account>
  static Map<String, Account> accounts = Map();

  static RpcClient client = RpcClient.fromAccount(Account.fromPrivateKey("70CuK4/E5OMpVWs3dyb3TiRccTW6dS2BExmYUKLtcc4="));

  static HashSet<ServerTuple> servers = HashSet();
  
  @override
  Widget build(BuildContext context) {
    servers.add(ServerTuple("129.78.10.53", 7822));
    return MaterialApp(
      title: 'Red Belly Blockchain Wallet',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: 'Red Belly Blockchain Wallet'),
    );
  }
}

//import 'package:flutter/material.dart';
//
//class Product {
//  const Product({this.name});
//  final String name;
//}
//
//typedef void CartChangedCallback(Product product, bool inCart);
//
//class ShoppingListItem extends StatelessWidget {
//  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
//      : product = product,
//        super(key: ObjectKey(product));
//
//  final Product product;
//  final bool inCart;
//  final CartChangedCallback onCartChanged;
//
//  Color _getColor(BuildContext context) {
//    // The theme depends on the BuildContext because different parts of the tree
//    // can have different themes.  The BuildContext indicates where the build is
//    // taking place and therefore which theme to use.
//
//    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
//  }
//
//  TextStyle _getTextStyle(BuildContext context) {
//    if (!inCart) return null;
//
//    return TextStyle(
//      color: Colors.black54,
//      decoration: TextDecoration.lineThrough,
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ListTile(
//      onTap: () {
//        onCartChanged(product, !inCart);
//      },
//      leading: CircleAvatar(
//        backgroundColor: _getColor(context),
//        child: Text(product.name[0]),
//      ),
//      title: Text(product.name, style: _getTextStyle(context)),
//    );
//  }
//}
//
//class ShoppingList extends StatefulWidget {
//  ShoppingList({Key key, this.products}) : super(key: key);
//
//  final List<Product> products;
//
//  // The framework calls createState the first time a widget appears at a given
//  // location in the tree. If the parent rebuilds and uses the same type of
//  // widget (with the same key), the framework re-uses the State object
//  // instead of creating a new State object.
//
//  @override
//  _ShoppingListState createState() => _ShoppingListState();
//}
//
//class _ShoppingListState extends State<ShoppingList> {
//  Set<Product> _shoppingCart = Set<Product>();
//
//  void _handleCartChanged(Product product, bool inCart) {
//    setState(() {
//      // When a user changes what's in the cart, we need to change _shoppingCart
//      // inside a setState call to trigger a rebuild. The framework then calls
//      // build, below, which updates the visual appearance of the app.
//
//      if (inCart)
//        _shoppingCart.add(product);
//      else
//        _shoppingCart.remove(product);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Shopping List'),
//      ),
//      body: ListView(
//        padding: EdgeInsets.symmetric(vertical: 8.0),
//        children: widget.products.map((Product product) {
//          return ShoppingListItem(
//            product: product,
//            inCart: _shoppingCart.contains(product),
//            onCartChanged: _handleCartChanged,
//          );
//        }).toList(),
//      ),
//    );
//  }
//}
//
//void main() {
//  runApp(MaterialApp(
//    title: 'Shopping App',
//    home: ShoppingList(
//      products: <Product>[
//        Product(name: 'Eggs'),
//        Product(name: 'Flour'),
//        Product(name: 'Chocolate chips'),
//      ],
//    ),
//  ));
//}