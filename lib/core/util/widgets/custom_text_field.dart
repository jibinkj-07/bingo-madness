import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String textFieldKey;
  final double borderRadius;
  final bool isObscure;
  final bool? readOnly;
  final bool? autoFocus;
  final Widget? icon;
  final String hintText;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final TextInputAction inputAction;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.textFieldKey,
    required this.isObscure,
    this.icon,
    this.maxLines,
    required this.hintText,
    required this.inputAction,
    this.validator,
    this.onSaved,
    this.suffixIcon,
    this.inputType,
    required this.textCapitalization,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.readOnly,
    this.minLines,
    required this.borderRadius, this.autoFocus, this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColor.secondaryColor,
      ),
      child: TextFormField(
        autofocus:autoFocus??false ,
        key: ValueKey(key),
        controller: controller,
        readOnly: readOnly ?? false,
        obscureText: isObscure,
        textInputAction: inputAction,
        keyboardType: inputType,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        validator: validator,
        onSaved: onSaved,
        maxLines: maxLines,
        minLines: minLines,
        initialValue: initialValue,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
          contentPadding: const EdgeInsets.all(15.0),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
