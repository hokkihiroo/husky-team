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
        title: Text(
          '입차리스트',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
  String dataId = '';
  String carNumber = '';
  String enterTime = '';
  String enterName = '';
  DateTime? outTime;
  String outName = '';

  ListModel({super.key, required this.adress});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(CARLIST + adress)
          .orderBy('enter')
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
                onTap: () async {
                  var document = docs[index];
                  print(document.id);
                  dataId = document.id;
                  carNumber = docs[index]['carNumber'];
                  Timestamp sam = docs[index]['enter']; //입차시각
                  enterTime = getInTime(sam); //입차시각 변환코드
                  enterName = docs[index]['enterName']; //입차한사람 이름

                  outTime = docs[index]['out'] is Timestamp
                      ? (docs[index]['out'] as Timestamp).toDate()
                      : null;

                  String outname = docs[index]['outName']; //출차한사람 이름
                  if (outname == null) {
                    outName = '';
                  } else {
                    outName = outname;
                  }

                  showCarInfoBottomSheet(context, dataId, carNumber, enterTime,
                      enterName, outName, outTime);

                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       title: Text('차정보'),
                  //     );
                  //   },
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CarListCard(
                    index: index + 1,
                    carNum: docs[index]['carNumber'],
                    inTime: docs[index]['enter'],
                    outTime: docs[index]['out'] is Timestamp
                        ? (docs[index]['out'] as Timestamp).toDate()
                        : null,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCarInfoBottomSheet(
      context, id, carNumber, enterTime, enterName, outName, outTime) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '차번호:$carNumber',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  // 여기에 다이얼로그의 내용을 추가할 수 있습니다.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('입차 시각 : $enterTime'),
                      Text('입차자 : $enterName'),
                      Text('출차 시각 : ${outTime != null ? getOutTime(outTime) : ''}'),
                      Text('출차자 : ${outName ?? ''}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
