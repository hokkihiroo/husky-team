import 'package:flutter/material.dart';

class BrandManageListCard extends StatelessWidget {
  final String carModel;


  BrandManageListCard({super.key, required this.carModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              carModel,
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '  >',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: Colors.grey.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
