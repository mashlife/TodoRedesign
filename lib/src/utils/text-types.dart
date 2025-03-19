import 'package:flutter/material.dart';
import 'package:todo_redesign/src/utils/colors.dart';

class TextType extends StatelessWidget {
  const TextType({
    super.key,
    required this.text,
    this.color,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.letterSpacing,
    this.maxLines,
  });

  TextType.titleText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.letterSpacing,
    this.maxLines,
  }) : color = Color(0xff212427);

  TextType.todoTitle(
    this.text, {
    super.key,
    this.fontSize = 19,
    this.fontWeight = FontWeight.w500,
    this.letterSpacing,
    this.maxLines,
  }) : color = Color(0xff212427);

  TextType.subTitle(
    this.text, {
    super.key,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w400,
    this.letterSpacing,
    this.maxLines,
  }) : color = Color(0xff212427);

  const TextType.placeholder(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
    this.letterSpacing,
    this.color = Colors.grey,
    this.maxLines,
  });

  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final double? letterSpacing;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? AppColors.creamWhite,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
      child: Text(text),
    );
  }
}
