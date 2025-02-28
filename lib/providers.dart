import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});
// テーマ状態を管理するStateNotifier
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // 初期値はライトテーマ(false)

  void toggleTheme() => state = !state;
}

//通知プロバイダの定義
final notificationProvider = StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier();
});
// 通知状態を管理するStateNotifier
class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier() : super(true); // 初期値は通知オン(true)

  void toggleNotification() => state = !state;
}