import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController dateController;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  const CustomDatePicker({
    Key? key,
    required this.dateController,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (selectedDate != null) {
      // 선택된 날짜를 문자열 형태로 저장
      String formattedDate = "${selectedDate.year}년 ${selectedDate.month.toString().padLeft(2, '0')}월 ${selectedDate.day.toString().padLeft(2, '0')}일";
      dateController.text = formattedDate; // 텍스트 필드에 표시
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true, // 날짜를 텍스트 필드로 직접 수정할 수 없게 설정
      decoration: InputDecoration(
        hintText: '생년월일 예) 1999년 01월 14일',
        labelText: '생년월일',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context), // 캘린더 버튼 클릭 시 날짜 선택
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
