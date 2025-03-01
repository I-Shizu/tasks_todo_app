import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  bool build() => false; // 初期値はライトテーマ(false)

  void toggleTheme() => state = !state;
}

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  bool build() => true; // 初期値は通知オン(true)

  void toggleNotification() => state = !state;
}