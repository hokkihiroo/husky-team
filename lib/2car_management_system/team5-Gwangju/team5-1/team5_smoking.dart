import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Team5Smoking extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  const Team5Smoking({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data();
        final name = data?['name']?.toString() ?? '';

        if (name.isEmpty) {
          return const SizedBox.shrink();
        }

        return Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
        );
      },
    );
  }
}