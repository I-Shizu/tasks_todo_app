import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:tasks_todo_app/schedule_entry.dart'; // schedule_entry.dart 内に scheduleProvider などが定義されている前提
import '../Data/task.dart'; // Taskクラス

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Firestoreからタスクを取得するtasksProviderProvider（生成済み）
    final tasksAsync = ref.watch(tasksProviderProvider);
    // タスクから計算したスケジュールのリスト
    final scheduleList = ref.watch(scheduleProviderProvider);

    // スケジュールエントリを日付ごとにグループ化（年月日単位で）
    final Map<DateTime, List<ScheduleEntry>> scheduleByDate = {};
    for (var entry in scheduleList) {
      final dateKey = DateTime(
        entry.scheduledDay.year,
        entry.scheduledDay.month,
        entry.scheduledDay.day,
      );
      if (!scheduleByDate.containsKey(dateKey)) {
        scheduleByDate[dateKey] = [];
      }
      scheduleByDate[dateKey]!.add(entry);
    }

    // 表示用に日付順にソート
    final sortedDates = scheduleByDate.keys.toList()..sort((a, b) => a.compareTo(b));

    return Scaffold(
      appBar: AppBar(
        title: const Text("タスクカレンダー"),
      ),
      body: Column(
        children: [
          // カレンダー表示
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              final dateKey = DateTime(day.year, day.month, day.day);
              // イベント（タスクタイトル）を表示用リストとして返す
              final events = scheduleByDate[dateKey] ?? [];
              return events.map((e) => e.taskTitle).toList();
            },
          ),
          const SizedBox(height: 8.0),
          // スケジュールの一覧表示
          Expanded(
            child: sortedDates.isEmpty
                ? const Center(child: Text("スケジュールがありません"))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final date = sortedDates[index];
                      final entries = scheduleByDate[date]!;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat("yyyy-MM-dd").format(date),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(),
                              ...entries.map((entry) => ListTile(
                                    title: Text(entry.taskTitle),
                                    subtitle: Text(
                                      "${entry.timeSlot} : ${entry.dailyAllocatedTime.toStringAsFixed(2)}分",
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}