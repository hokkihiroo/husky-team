import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_husky/1insa/schdule/colors.dart';
import 'package:team_husky/1insa/schdule/schedule_card.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    asd();
  }

  void asd() async {
    await initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스케쥴'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_kr',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            calendarStyle: CalendarStyle(
              isTodayHighlighted: false,
              defaultDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: LIGHT_GREY_COLOR,
              ),
              weekendDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: LIGHT_GREY_COLOR,
              ),
              selectedDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: PRIMARY_COLOR,
                  width: 1.0,
                ),
              ),
              defaultTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: DARK_GREY_COLOR,
              ),
              weekendTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: DARK_GREY_COLOR,
              ),
            ),
          ),
          // Expanded(
          //   child: _buildEventList(),
          // ),
          _Banner(
            selectedDate: _focusedDay,
            count: 4,
          ),

          ScheduleCard(
            startTime: 8,
            content: '김재곤',
          ),
          ScheduleCard(
            startTime: 8,
            content: '최원준',
          ),
          ScheduleCard(
            startTime: 12,
            content: '김도형',
          ),
          ScheduleCard(
            startTime: 12,
            content: '염호경',
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    // 날짜에 해당하는 이벤트를 불러오는 코드
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('date', isEqualTo: _selectedDay)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final events = snapshot.data!.docs;
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return ListTile(
              title: Text(event['title']),
              subtitle: Text(event['description']),
            );
          },
        );
      },
    );
  }
}

class _Banner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const _Banner({super.key, required this.selectedDate, required this.count});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
              style: textStyle,
            ),
            Text(
              '$count개',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
