import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomField({
    super.key,
    this.hintText = "",
    required this.controller,
    this.isObscure = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing.";
        }
        return null;
      },
      obscureText: isObscure,
    );
  }
}
