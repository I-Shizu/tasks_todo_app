import '../task_data.dart';

class TaskScheduler {
  // ユーザーの空き時間（ここでは仮のデータ）
  List<DateTime> availableTimes = [
    DateTime(2025, 2, 26, 9, 0),
    DateTime(2025, 2, 26, 10, 0),
    DateTime(2025, 2, 27, 9, 0),
    DateTime(2025, 2, 27, 10, 0),
  ];

  List<Task> tasks = [];

  // タスクを優先度と締め切りでソート
  void sortTasks() {
    tasks.sort((a, b) {
      if (a.priority == b.priority) {
        return a.deadline.compareTo(b.deadline); // 同じ優先度なら期限順
      }
      return a.priority.compareTo(b.priority); // 優先度順
    });
  }

  // タスクを空き時間に割り当てる
  void assignTasks() {
    sortTasks();
    
    int availableTimeIndex = 0;

    for (var task in tasks) {
      int remainingTime = task.estimatedTime;

      while (remainingTime > 0 && availableTimeIndex < availableTimes.length) {
        // 空き時間にタスクを割り当て
        DateTime currentAvailableTime = availableTimes[availableTimeIndex];
        print('Assigning ${task.title} to $currentAvailableTime');
        
        // 1時間ずつ割り当て（仮定）
        int timeToAssign = remainingTime >= 60 ? 60 : remainingTime;
        remainingTime -= timeToAssign;

        // 次の空き時間へ
        availableTimeIndex++;
      }

      if (remainingTime > 0) {
        print('Task ${task.title} could not be fully scheduled.');
      }
    }
  }
}