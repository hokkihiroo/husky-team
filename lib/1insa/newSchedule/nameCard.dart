import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {
  final String name;

  const NameCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
