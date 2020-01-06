import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.lable,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.validator,
  }) : super(key: key);

  final String lable;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: lable,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.white),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
    );
  }
}
