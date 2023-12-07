import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/car_management_system/team1/team1_adress_const.dart';
import 'package:team_husky/car_management_system/team1/team1_car_card.dart';

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  DateTime selectedDate = DateTime.now();
  String DBAdress = formatTodayDate();

  void _previousDay() {
    final goToOneDayAgo = selectedDate.subtract(Duration(days: 1));
    final year = goToOneDayAgo.year.toString();
    final month = goToOneDayAgo.month.toString().padLeft(2, '0');
    final day = goToOneDayAgo.day.toString().padLeft(2, '0');
    setState(() {
      selectedDate = goToOneDayAgo;
      DBAdress = year + month + day;
    });
  }

  void _nextDay() {
    final today = DateTime.now();
    final nextDay = selectedDate.add(Duration(days: 1));
    final year = nextDay.year.toString();
    final month = nextDay.month.toString().padLeft(2, '0');
    final day = nextDay.day.toString().padLeft(2, '0');

    setState(() {
      if (nextDay.isBefore(today)) {
        setState(() {
          selectedDate = nextDay;
          DBAdress = year + month + day;
        });
      }
    });
  }

  void goToday() {
    setState(() {
      selectedDate = DateTime.now();
      DBAdress = formatTodayDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('입차리스트'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _DateControl(
            onPressLeft: _previousDay,
            onPressRight: _nextDay,
            onPressGoToday: goToday,
            selectedDate: selectedDate,
          ),
          _ListState(),
          ListModel(
            adress: DBAdress,
          ),
        ],
      ),
    );
  }
}

class _DateControl extends StatelessWidget {
  final VoidCallback onPressLeft;
  final VoidCallback onPressRight;
  final VoidCallback onPressGoToday;
  final DateTime selectedDate;

  const _DateControl(
      {super.key,
      required this.onPressLeft,
      required this.onPressRight,
      required this.onPressGoToday,
      required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.white,
          ),
          onPressed: onPressLeft,
        ),
        Text(
          "${selectedDate.toLocal()}".split(' ')[0],
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right_outlined,
            color: Colors.white,
          ),
          onPressed: onPressRight,
        ),
        SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: onPressGoToday,
          child: Text(
            'TODAY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _ListState extends StatelessWidget {
  const _ListState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '번호',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          Text(
            '차량번호',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          Text(
            '입차시각',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          Text(
            '출차시각',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ListModel extends StatelessWidget {
  final String adress;

  const ListModel({super.key, required this.adress});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(CARLIST + adress)
          //  .orderBy('createdAt')
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CarListCard(
                    index: index + 1,
                    carNum: docs[index]['carNumber'],
                    inTime: docs[index]['enter'],
                    outTime: '',
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
