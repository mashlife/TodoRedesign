// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:todo_redesign/src/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  bool isObscure;
  bool obscureIcon;
  final TextInputAction? textInputAction;
  final String? Function(String?)? onChanged;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? fill;
  final InputBorder? focusBorder;
  final int maxLines;

  CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.isObscure = false,
    this.obscureIcon = false,
    this.textInputAction,
    this.onChanged,
    this.radius,
    this.padding,
    this.textStyle,
    this.fill,
    this.focusBorder,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        obscureText: widget.isObscure,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: widget.textStyle,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          contentPadding: widget.padding,
          suffixIcon:
              widget.obscureIcon
                  ? InkWell(
                    onTap: () {
                      setState(() {
                        widget.isObscure = !widget.isObscure;
                      });
                    },
                    child: Icon(
                      widget.isObscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  )
                  : null,
          filled: true,
          fillColor: widget.fill ?? AppColors.creamWhite,
          focusedBorder: widget.focusBorder,
          hintText: widget.hintText ?? "e.g. Example",
          border: OutlineInputBorder(
            borderRadius: widget.radius ?? BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
