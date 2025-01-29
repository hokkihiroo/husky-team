import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2_carschedule_model.dart';

class Team2CarSchedule extends StatefulWidget {
  const Team2CarSchedule({super.key});

  @override
  State<Team2CarSchedule> createState() => _Team2CarScheduleState();
}

class _Team2CarScheduleState extends State<Team2CarSchedule> {
  DateTime selectedDate = DateTime.now();
  String DBAdress = formatTodayDate();

  List<RowFirst> rowFirst = [];

  void _addRow() {
    setState(() {
      rowFirst.add(RowFirst(number: rowFirst.length + 1));
    });
  }

  void _previousDay() {
    final goToOneDayAgo = selectedDate.subtract(Duration(days: 1));
    final year = goToOneDayAgo.year.toString();
    final month = goToOneDayAgo.month.toString().padLeft(2, '0');
    final day = goToOneDayAgo.day.toString().padLeft(2, '0');
    setState(() {
      selectedDate = goToOneDayAgo;
      DBAdress = year + month + day;
      rowFirst.clear(); // 날짜 변경 시 rowFirst 초기화
    });
    print(DBAdress);
  }

  void _nextDay() {
    final today = DateTime.now();
    final nextDay = selectedDate.add(Duration(days: 1));
    final year = nextDay.year.toString();
    final month = nextDay.month.toString().padLeft(2, '0');
    final day = nextDay.day.toString().padLeft(2, '0');
    setState(() {
      setState(() {
        selectedDate = nextDay;
        DBAdress = year + month + day;
        rowFirst.clear(); // 날짜 변경 시 rowFirst 초기화
      });
    });
    print(DBAdress);
  }

  void goToday() {
    setState(() {
      selectedDate = DateTime.now();
      DBAdress = formatTodayDate();
      rowFirst.clear(); // 날짜 변경 시 rowFirst 초기화
      print(DBAdress);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '시승차량 스케줄',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
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
            Team2CarScheduleModel(
              Adress: DBAdress,
              rowFirst: rowFirst,
              addRow: _addRow,
            )
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
        SizedBox(
          width: 2,
        ),
        Text(
          getWeeks(selectedDate.weekday),
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



