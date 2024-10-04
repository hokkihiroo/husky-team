import 'package:flutter/material.dart';

class ManageSelectCategoryCard extends StatelessWidget {
  final String subject;
  final String date;

  const ManageSelectCategoryCard({super.key, required this.subject, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      // vertical padding reduced
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced inner padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 4, // Reduced height of the SizedBox
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date, // 여기에 원하는 날짜를 넣으세요.
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 14, // 크기를 더 작게 조정
                      fontWeight: FontWeight.normal, // 일반 굵기로 변경 (필요시)
                      color: Colors.blueGrey, // 회색으로 변경
                    ),
                  ),
                  Text(
                    '>',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 14, // 크기를 더 작게 조정
                      fontWeight: FontWeight.normal, // 일반 굵기로 변경 (필요시)
                      color: Colors.blueGrey, // 회색으로 변경
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
