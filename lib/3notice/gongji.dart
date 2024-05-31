import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/3notice/Address.dart';
import 'package:team_husky/3notice/gongjiCard.dart';

import '../notification.dart';

class Notication extends StatefulWidget {
  const Notication({super.key});

  @override
  State<Notication> createState() => _NoticationState();
}

class _NoticationState extends State<Notication> {
  String formattedDate = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(GONGJI)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            Timestamp timestamp = docs[index]['createdAt'];
            DateTime date = timestamp.toDate();
            formattedDate = DateFormat('yyyy.MM.dd').format(date);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GongjiCard(
                  subject: docs[index]['subject'],
                  date: formattedDate,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
