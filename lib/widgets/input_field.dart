import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function validator;
  final Function onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
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
