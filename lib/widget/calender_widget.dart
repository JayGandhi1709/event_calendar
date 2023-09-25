import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime currentDate;
  const CalenderWidget({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      currentDay: currentDate,
    );
  }
}
