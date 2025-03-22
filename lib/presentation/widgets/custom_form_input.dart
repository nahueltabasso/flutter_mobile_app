import 'package:flutter/material.dart';

class CustomFormInput extends StatelessWidget {

  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final String? initialValue;
  final String? errorMessage;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool autocorrect;
  final bool? enabled;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomFormInput({
    super.key, 
    required this.labelText, 
    required this.hintText,
    required this.prefixIcon, 
    required this.onChanged,
    this.obscureText = false,
    this.initialValue = '', 
    this.errorMessage,
    this.keyboardType = TextInputType.text, 
    this.autocorrect = false, 
    this.enabled = true, 
    this.suffixIcon, 
    this.validator,
    this.controller, 
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;    

    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: hasError ? Colors.red : Colors.lightBlue),
        suffixIcon: Icon(suffixIcon, color: hasError ? Colors.red : Colors.lightBlue),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        errorText: errorMessage,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      initialValue: initialValue,
      obscureText: obscureText!,
      controller: controller,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
    );  
  }
}
