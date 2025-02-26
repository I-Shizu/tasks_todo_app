import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../task_data.dart';
import '../task_scheduler.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now(); // 初期化
  }

  // タスクが割り当てられている日付にマークを表示
  Map<DateTime, List<String>> tasks = {
    DateTime(2025, 2, 26): ['Task 1'],
    DateTime(2025, 2, 27): ['Task 2', 'Task 3'],
  };

  // カレンダーの上部に選択した日付のタスクを表示
  Widget _buildTaskListForDay(DateTime selectedDay) {
    final taskForSelectedDay = tasks[selectedDay] ?? [];
    return ListView.builder(
      itemCount: taskForSelectedDay.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(taskForSelectedDay[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return tasks[day] ?? [];
            },
          ),
          Expanded(child: _buildTaskListForDay(_selectedDay)),
        ],
      ),
    );
  }
}