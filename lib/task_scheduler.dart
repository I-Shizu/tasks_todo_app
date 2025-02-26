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

  // タスクをプロパティでソートする関数  
  // 期日 → 優先度 → めんどくささ → 所要時間 の順でソート（各プロパティの値の意味に応じて順序を調整してください）
  void sortTasksAdvanced() {
    tasks.sort((a, b) {
      int result = a.deadline.compareTo(b.deadline);
      if (result != 0) return result;
      result = a.priority.compareTo(b.priority);
      if (result != 0) return result;
      result = a.mendokusasa.compareTo(b.mendokusasa);
      if (result != 0) return result;
      return a.estimatedTime.compareTo(b.estimatedTime);
    });
  }

  // タスクを空き時間に割り当て、各空き時間（slot）ごとにタスク一覧を返す
  // 1スロットあたり最大60分ずつ割り当てる（必要に応じて調整）
  Map<DateTime, List<Task>> scheduleTasksAdvanced(List<Task> tasks) {
    this.tasks = tasks;
    sortTasksAdvanced();

    Map<DateTime, List<Task>> scheduled = {};
    int slotIndex = 0;

    for (var task in tasks) {
      int remainingTime = task.estimatedTime;

      while (remainingTime > 0 && slotIndex < availableTimes.length) {
        DateTime currentSlot = availableTimes[slotIndex];
        // 1スロットあたり最大60分割り当て
        int assignTime = remainingTime >= 60 ? 60 : remainingTime;
        remainingTime -= assignTime;

        // currentSlot にタスクを追加（同一タスクが複数スロットにまたがる場合でも同じタスクとして登録）
        scheduled.putIfAbsent(currentSlot, () => []);
        scheduled[currentSlot]!.add(task);

        // 次の空き時間へ
        slotIndex++;
      }

      if (remainingTime > 0) {
        print('Task ${task.title} could not be fully scheduled.');
      }
    }

    return scheduled;
  }
}