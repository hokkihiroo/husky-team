import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_husky/1insa/schdule/colors.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final String content;

  const ScheduleCard(
      {super.key, required this.startTime, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5.0, 5.0, 5.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(
                startTime: startTime,
              ),
              SizedBox(
                width: 16.0,
              ),
              _Content(
                content: content,
              ),
              SizedBox(
                width: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;

  const _Time({
    super.key,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${startTime.toString().padLeft(2, '0')}:00', style: textStyle),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}
