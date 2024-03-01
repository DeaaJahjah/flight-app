import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Icon prefixIcon;
  final Color mainColor;
  final Color secondaryColor;
  final bool isTextObscure;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final bool readOnly;
  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.mainColor,
    required this.secondaryColor,
    required this.controller,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.isTextObscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: secondaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor),
        ),
      ),
      cursorColor: mainColor,
      obscureText: isTextObscure,
      style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
    );
  }
}
