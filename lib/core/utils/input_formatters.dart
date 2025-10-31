import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 10) {
      return oldValue;
    }

    String formatted = digitsOnly;
    if (digitsOnly.length > 5) {
      formatted = '${digitsOnly.substring(0, 5)} ${digitsOnly.substring(5)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AadharInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 12) {
      return oldValue;
    }

    String formatted = digitsOnly;
    if (digitsOnly.length > 8) {
      formatted =
          '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4, 8)} ${digitsOnly.substring(8)}';
    } else if (digitsOnly.length > 4) {
      formatted = '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PincodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 6) {
      return oldValue;
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

class PANInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase();

    if (text.length > 10) {
      return oldValue;
    }

    final alphanumericOnly = text.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    return TextEditingValue(
      text: alphanumericOnly,
      selection: TextSelection.collapsed(offset: alphanumericOnly.length),
    );
  }
}

class OTPInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 6) {
      return oldValue;
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    final lettersAndSpacesOnly = text.replaceAll(RegExp(r"[^a-zA-Z\s.']"), '');

    return TextEditingValue(
      text: lettersAndSpacesOnly,
      selection: TextSelection.collapsed(offset: lettersAndSpacesOnly.length),
    );
  }
}
