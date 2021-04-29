// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Custom_input extends StatelessWidget {
  final String hint ;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final double contentPaddingVertical;
  final double contentPaddingHorizontal;
  Custom_input({Key key, this.hint, this.onChanged, this.onSubmitted, this.focusNode, this.textInputAction, this.isPasswordField, this.contentPaddingVertical, this.contentPaddingHorizontal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 62,
      margin: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12)
        ),
        child: TextField(
          obscureText: isPasswordField ?? false,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint ?? "ادخل معلومات",
            contentPadding: EdgeInsets.symmetric(
              vertical: contentPaddingVertical ?? 18,
              horizontal: contentPaddingHorizontal ?? 18
            )
          ),
        ),
      ),
    );
  }
}
