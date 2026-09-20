import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'education_card.dart';
import 'education_detail.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  String collectionAddress = '0oB68hipcx7qvyDunh4F';
  String category = '';

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Column(
        children: [
          // 교육 카테고리
          Container(
            height: 66,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('education')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: navy,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '교육 카테고리를 불러오지 못했습니다.',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      '등록된 교육 카테고리가 없습니다.',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 12,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final String localCategory = doc['category'];
                    final bool selected = collectionAddress == doc.id;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            collectionAddress = doc.id;
                            category = localCategory;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? navy : background,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: selected
                                  ? navy
                                  : const Color(0xFFE2E5EA),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 17,
                                color: selected ? goldLight : textGrey,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                localCategory,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : textGrey,
                                  fontSize: 14,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 교육 목록
          Expanded(
            child: EduList(
              collectionAddress: collectionAddress,
              category: category,
            ),
          ),
        ],
      ),
    );
  }
}

class EduList extends StatelessWidget {
  final String collectionAddress;
  final String category;

  const EduList({
    super.key,
    required this.collectionAddress,
    required this.category,
  });

  static const Color navy = Color(0xFF17233C);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('education')
          .doc(collectionAddress)
          .collection('list')
          .orderBy('createdAt')
          .snapshots(),
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: navy,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '교육 내용을 불러오지 못했습니다.',
              style: TextStyle(
                color: textGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 28,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE2E5EA),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.07),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: navy,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '등록된 교육 내용이 없습니다.',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            10,
            10,
            10,
            20,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data();

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 7,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationDetail(
                        category: category,
                        subject: data['subject'],
                        writer: data['writer'],
                        contents: data['contents'],
                        docId: docs[index].id,
                        categoryDocId: collectionAddress,
                        imageUrls: data['images'] != null
                            ? Map<String, String>.from(
                          data['images'],
                        )
                            : {},
                      ),
                    ),
                  );
                },
                child: EducationCard(
                  subject: data['subject'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}