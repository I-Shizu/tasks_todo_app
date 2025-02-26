import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../task_data.dart';
import '../task_scheduler.dart';
import '../firebase_repository.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  final TaskRepository taskRepository = TaskRepository();
  


  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
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
              return <String>[];
            },
          ),
          // Firebase のタスク取得後、TaskScheduler で日付ごとに振り分けたタスクを表示
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: taskRepository.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  var firebaseTasks = snapshot.data!;
                  // タスクを日付ごとに振り分け
                  var scheduledTasks = TaskScheduler().scheduleTasksAdvanced(firebaseTasks);
                  // 今日以降の日付を抽出して昇順にソート
                  var today = DateTime.now();
                  List<DateTime> sortedDates = scheduledTasks.keys
                      .where((date) => date.isAfter(today.subtract(Duration(days: 1))))
                      .toList();
                  sortedDates.sort((a, b) => a.compareTo(b));
                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      var date = sortedDates[index];
                      var tasksForDate = scheduledTasks[date] ?? [];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${date.year}-${date.month}-${date.day}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Divider(),
                              ...tasksForDate.map((task) => Row(
                                    children: [
                                      Checkbox(
                                        value: task.completed,
                                        onChanged: (bool? value) {
                                          taskRepository.updateTask(task.copyWith(completed: value!));
                                          setState(() {
                                            task.completed = value;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('データがありません'));
              },
            ),
          ),
        ],
      ),
    );
  }
}