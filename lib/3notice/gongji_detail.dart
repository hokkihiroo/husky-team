import 'package:flutter/material.dart';

class GongjiDetail extends StatefulWidget {
  const GongjiDetail({super.key});

  @override
  State<GongjiDetail> createState() => _GongjiDetailState();
}

class _GongjiDetailState extends State<GongjiDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '공지사항',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

    );
  }
}
