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
  final ScrollController _processedTaskScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  void dispose() {
    _processedTaskScrollController.dispose();
    super.dispose();
  }

  // カレンダー部分で日付をタップした時、横スクロールの該当位置へ移動
  void _scrollToScheduledTask(List<DateTime> sortedDates) {
    int selectedIndex = sortedDates.indexWhere((date) => isSameDay(date, _selectedDay));
    if (selectedIndex != -1) {
      // 各アイテムの幅は 200 + 16（左右のマージンなど）の想定
      _processedTaskScrollController.animateTo(
        selectedIndex * 216.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
              // スケジュール済みタスクの横リストに合わせて移動（後続の StreamBuilder 内で scrollToScheduledTask を実行）
            },
            eventLoader: (day) {
              // ※既存の tasks マップはこちらで使用（Firebaseのタスクとは別途）
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
                  // TaskScheduler の関数でタスクを日付ごとに振り分け
                  var scheduledTasks = TaskScheduler().scheduleTasksAdvanced(firebaseTasks);
                  // 今日以降の日付を抽出し、昇順にソート、最大５件に絞る
                  var today = DateTime.now();
                  List<DateTime> sortedDates = scheduledTasks.keys
                      .where((date) => date.isAfter(today.subtract(Duration(days: 1))))
                      .toList();
                  sortedDates.sort((a, b) => a.compareTo(b));
                  if (sortedDates.length > 5) {
                    sortedDates = sortedDates.sublist(0, 5);
                  }
                  // カレンダーの日付タップ時に横リストのスクロールを実施
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToScheduledTask(sortedDates);
                  });
                  return Column(
                    children: [
                      // 横にスクロールするタスクスケジュール部分
                      Container(
                        height: 150,
                        child: ListView.builder(
                          controller: _processedTaskScrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: sortedDates.length,
                          itemBuilder: (context, index) {
                            var date = sortedDates[index];
                            var tasksForDate = scheduledTasks[date] ?? [];
                            return GestureDetector(
                              onTap: () {
                                // 横タップ時に、カレンダーの日付選択と同様の処理を実行
                                setState(() {
                                  _selectedDay = date;
                                  _focusedDay = date;
                                });
                              },
                              child: Container(
                                width: 200,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${date.year}-${date.month}-${date.day}",
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Divider(),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: tasksForDate.length,
                                        itemBuilder: (context, i) {
                                          var task = tasksForDate[i];
                                          return Text(task.title,
                                              overflow: TextOverflow.ellipsis);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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