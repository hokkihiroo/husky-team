import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'team1_adress_const.dart';

class Team1LocationName extends StatefulWidget {
  const Team1LocationName({super.key});

  @override
  State<Team1LocationName> createState() => _Team1LocationnameState();
}

class _Team1LocationnameState extends State<Team1LocationName> {
  Future<void> _editLocationName(
      String fieldName,
      String currentValue,
      ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return _LocationEditDialog(
          fieldName: fieldName,
          currentValue: currentValue,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .doc(parkLocation)
          .snapshots(),
      builder: (context, snapshot) {
        // 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        // 문서가 없거나 에러 발생
        if (snapshot.hasError ||
            !snapshot.hasData ||
            !snapshot.data!.exists) {
          return const SizedBox();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  data['a'] ?? '로터',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),

              const SizedBox(
                width: 5,
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _editLocationName(
                      'b',
                      data['b'] ?? '외벽',
                    );
                  },
                  child: Text(
                    data['b'] ?? '외벽',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _editLocationName(
                      'c',
                      data['c'] ?? '광장',
                    );
                  },
                  child: Text(
                    data['c'] ?? '광장',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 5,
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _editLocationName(
                      'd',
                      data['d'] ?? '문앞',
                    );
                  },
                  child: Text(
                    data['d'] ?? '문앞',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 5,
              ),

              Expanded(
                child: Text(
                  data['e'] ?? '신사',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


// 위치명 수정 다이얼로그
class _LocationEditDialog extends StatefulWidget {
  final String fieldName;
  final String currentValue;

  const _LocationEditDialog({
    required this.fieldName,
    required this.currentValue,
  });

  @override
  State<_LocationEditDialog> createState() =>
      _LocationEditDialogState();
}

class _LocationEditDialogState
    extends State<_LocationEditDialog> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
      text: widget.currentValue,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newValue = controller.text.trim();

    // 정확히 2글자가 아니면 저장 불가
    if (newValue.characters.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치명은 반드시 두 글자로 입력해주세요.'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .doc(parkLocation)
        .update({
      widget.fieldName: newValue,
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('위치명 수정'),

      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 2,
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
        ],
        decoration: const InputDecoration(
          hintText: '두 글자를 입력하세요',
        ),
      ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: _save,
              child: const Text('저장'),
            ),
          ],
        ),


      ],
    );
  }
}