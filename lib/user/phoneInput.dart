import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController phoneController;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  const PhoneNumberInput({
    Key? key,
    required this.phoneController,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: '전화번호 예) 010-1234-5678',
        labelText: '전화번호',
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
        TextInputFormatter.withFunction((oldValue, newValue) {
          // 입력값을 실시간으로 포맷팅
          final input = newValue.text.replaceAll(RegExp(r'\D'), ''); // 숫자만 남김
          String formatted;
          if (input.length > 10) {
            formatted =
            '${input.substring(0, 3)}-${input.substring(3, 7)}-${input.substring(7)}';
          } else if (input.length > 6) {
            formatted =
            '${input.substring(0, 3)}-${input.substring(3, 6)}-${input.substring(6)}';
          } else if (input.length > 3) {
            formatted = '${input.substring(0, 3)}-${input.substring(3)}';
          } else {
            formatted = input;
          }
          return TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }),
      ],
      validator: validator,
      onSaved: onSaved,
    );
  }
}
