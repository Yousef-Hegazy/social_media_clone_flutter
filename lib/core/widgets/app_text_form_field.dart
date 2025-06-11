import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onSubmitted;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPasswordField;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator;
  final String? initialValue;

  const AppTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.isPasswordField = false,
    this.focusNode,
    this.minLines,
    this.maxLines,
    this.validator,
    this.initialValue,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      obscureText: widget.isPasswordField && !isPasswordVisible,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      validator: widget.validator,
      decoration: InputDecoration(
        filled: true,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, size: 20)
            : null,
        hintText: widget.hintText,
        suffixIcon: widget.isPasswordField
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}
