import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase_repository.dart';
import 'task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_entry.g.dart';

class ScheduleEntry {
  final String taskId;
  final String taskTitle;
  final DateTime scheduledDay;
  final String timeSlot;
  final double dailyAllocatedTime;

  ScheduleEntry({
    required this.taskId,
    required this.taskTitle,
    required this.scheduledDay,
    required this.timeSlot,
    required this.dailyAllocatedTime,
  });
}

// タスクのスケジュールを計算する関数
List<ScheduleEntry> scheduleTasks(List<Task> tasks) {
  DateTime now = DateTime.now();
  List<ScheduleEntry> schedule = [];

  for (Task task in tasks) {
    // 期日の1日前までの日数
    int availableDays = task.deadline.difference(now).inDays - 1;
    if (availableDays <= 0) availableDays = 1;

    int allocationDays;
    // 優先度に応じた作業期間
    if (task.priority == 1) {
      allocationDays = (availableDays / 3).ceil();
    } else if (task.priority == 2) {
      allocationDays = (availableDays / 2).ceil();
    } else {
      allocationDays = availableDays;
    }

    // 1日あたりの作業時間（分）
    double dailyAllocation = task.estimatedTime / allocationDays;

    // めんどくささによる時間帯の決定
    String timeSlot;
    if (task.mendokusasa == 1) {
      timeSlot = "朝";
    } else if (task.mendokusasa == 2) {
      timeSlot = "夜";
    } else if (task.mendokusasa == 3) {
      timeSlot = "昼";
    } else {
      timeSlot = "未設定";
    }

    // 各日に割り当てる
    for (int i = 0; i < allocationDays; i++) {
      DateTime scheduledDay = now.add(Duration(days: i));
      schedule.add(ScheduleEntry(
        taskId: task.id,
        taskTitle: task.title,
        scheduledDay: scheduledDay,
        timeSlot: timeSlot,
        dailyAllocatedTime: dailyAllocation,
      ));
    }
  }
  return schedule;
}

// Riverpodプロバイダー：スケジュール計算を実行するプロバイダー
@riverpod
List<ScheduleEntry> scheduleProvider(Ref ref) {
  final user = FirebaseAuth.instance.currentUser;
  final tasks = ref.watch(userTasksProvider(user!.uid));

  return tasks.when(
    data: (tasks) => scheduleTasks(tasks),
    loading: () => [],
    error: (_, __) => [],
  );
}