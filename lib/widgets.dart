import 'package:flutter/material.dart';

InputDecoration textFieldInputTextDec(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}
