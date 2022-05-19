import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    this.controller,
    this.labelText,
    this.obscureText = false,
    this.validator,
    this.onEditingComplete,
    this.inputFormatter,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
  }) : super(key: key);

  final String? labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatter,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        isDense: true,
        labelText: labelText,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
