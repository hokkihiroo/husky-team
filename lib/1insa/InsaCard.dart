import 'package:flutter/material.dart';

class OrganizationCard extends StatelessWidget {
  final String name;
  final String team;
  final String position;

  const OrganizationCard(
      {super.key,
        required this.position,
        required this.name,
        required this.team});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        height: 50,
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                letterSpacing: 3.0,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              team,
              style: TextStyle(
                letterSpacing: 3.0,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              position,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}