import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');

    // Format as "XX XXX XXX"
    if (newText.length > 2 && newText.length <= 5) {
      newText = '${newText.substring(0, 2)} ${newText.substring(2)}';
    } else if (newText.length > 5) {
      newText = '${newText.substring(0, 2)} ${newText.substring(2, 5)} ${newText.substring(5)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
