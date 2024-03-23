import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'\d+(\.\d{0,2})?');
    final String newString = regEx.stringMatch(newValue.text) ?? '';
    return newString == newValue.text ? newValue : oldValue;
  }
}
