import 'package:flutter/material.dart';
import 'package:team_husky/user/color.dart';

class CustomTextForm extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final Icon? icon;

// 비밀번호 보기 / 숨기기 버튼 등에 사용
  final Widget? suffixIcon;

  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final int? maxLines;
  final int? maxLength;

  const CustomTextForm({
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autoFocus = false,
    this.onChanged,
    this.icon,
    this.suffixIcon,
    this.onSaved,
    this.validator,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    const Color navy = Color(0xFF17233C);
    const Color textGrey = Color(0xFF7A808B);
    const Color borderColor = Color(0xFFD9DEE8);
    const Color backgroundColor = Color(0xFFF8F8F6);

    final baseBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: borderColor,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(16),
    );

    final focusedBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: navy,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(16),
    );

    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      autofocus: autoFocus,
      cursorColor: navy,
      onSaved: onSaved,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,

// 기존 코드처럼 한 줄 입력 유지
      maxLines: 1,
      maxLength: maxLength,

      decoration: InputDecoration(
// 왼쪽 아이콘
        prefixIcon: icon == null
            ? null
            : IconTheme(
                data: const IconThemeData(
                  color: textGrey,
                  size: 21,
                ),
                child: icon!,
              ),

// 오른쪽 아이콘
        suffixIcon: suffixIcon,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),

        hintText: hintText,
        errorText: errorText,

        hintStyle: const TextStyle(
          color: textGrey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        fillColor: backgroundColor,
        filled: true,

        border: baseBorder,
        enabledBorder: baseBorder,

        focusedBorder: focusedBorder,

        errorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.0,
          ),
        ),

        focusedErrorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
