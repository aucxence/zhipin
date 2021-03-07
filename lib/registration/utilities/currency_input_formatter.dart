import 'package:flutter/services.dart';
import "package:intl/intl.dart";

class CurrencyInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

if(newValue.selection.baseOffset == 0){
  print(true);
  return newValue;
}

String newText = newValue.text.toUpperCase();

return newValue.copyWith(
    text: newText,
    selection: new TextSelection.collapsed(offset: newText.length));
  }
}