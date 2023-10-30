import 'package:flutter/material.dart';
import 'package:team_husky/user/color.dart';

class CustomTextForm extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final Icon? icon;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;

  const CustomTextForm(
      {super.key,
        this.hintText,
        this.errorText,
        this.obscureText = false,
        this.autoFocus = false, this.onChanged, this.icon, this.onSaved, this.validator});

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: TEXT_COLOR,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(35.0),
      ),
    );

    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      autofocus: autoFocus,
      cursorColor: MAIN_COLOR,
      onSaved: onSaved,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: icon,
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: BG_COLOR,
        filled: true,
        border: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: TEXT_COLOR,
          ),
        ),
      ),
    );
  }
}