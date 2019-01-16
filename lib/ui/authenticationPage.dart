import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import 'homePage.dart';

class AuthenticationPage extends StatefulWidget {
  int fields;
  var onSubmit;
  double fieldWidth;
  double fontSize;
  bool isTextObscure;
  bool showFieldAsBox;
  final String title;

  AuthenticationPage(
      {this.fields: 4,
      this.onSubmit,
      this.fieldWidth: 40.0,
      this.fontSize: 20.0,
      this.isTextObscure: false,
      this.showFieldAsBox: false,
      this.title: 'Red Belly Blockchain Wallet'})
      : assert(fields > 0);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  List<String> _pin;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _pin = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
  }

  @override
  void dispose() {
    _focusNodes.forEach((FocusNode f) => f.dispose());
    _textControllers.forEach((TextEditingController t) => t.dispose());
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
  }

  Widget buildTextField(int i, BuildContext context) {
    _focusNodes[i] = FocusNode();
    _textControllers[i] = TextEditingController();

    _focusNodes[i].addListener(() {
      if (_focusNodes[i].hasFocus) {
        _textControllers[i].clear();
      }
    });

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: widget.fontSize),
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        decoration: InputDecoration(
            counterText: "",
            border: widget.showFieldAsBox
                ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
                : null),
        onChanged: (String str) {
          _pin[i] = str;
          if (i + 1 != widget.fields) {
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          } else {
            clearTextFields();
            FocusScope.of(context).requestFocus(_focusNodes[0]);
            widget.onSubmit(_pin.join());
          }
        },
        onSubmitted: (String str) {
          clearTextFields();
          widget.onSubmit(_pin.join());
        },
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    FocusScope.of(context).requestFocus(_focusNodes[0]);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: generateTextFields(context),
    );
  }
}
