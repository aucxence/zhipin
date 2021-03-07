import 'package:flutter/material.dart';

Widget genderRadioButton(value, genre, Function callback, Color activeColor) {
  return Radio(
      value: value,
      groupValue: genre,
      activeColor: activeColor,
      onChanged: callback);
}
