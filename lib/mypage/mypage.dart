import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/user/user_auth.dart';
import 'package:team_husky/user/user_screen.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UserScreen();
                      },
                    ),
                  );
                },
                child: Text('로그아웃'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                User? currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser != null) {
                  String userId = currentUser.uid;

                  await FIRESTORE
                      .collection('user/KZwZFZ6RV8WKvynPHZDs/bonsa')
                      .doc(userId)
                      .delete();
                  await currentUser.delete();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UserScreen();
                      },
                    ),
                  );
                }
              } catch (e) {
                print('Error deleting user: $e');
              }
            },
            child: Text('퇴사하기'),
          ),
        ],
      ),
    );
  }
}
