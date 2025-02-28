import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_todo_app/UI/web_view_screen.dart';
import 'package:tasks_todo_app/providers.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    final isNotificationEnabled = ref.watch(notificationProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'アプリについて',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true, // リストビューの高さをコンテンツに合わせる
              physics: NeverScrollableScrollPhysics(), // スクロールを無効化
              children: [
                _urlCard(
                  context,
                  icon: Icons.contact_mail,
                  title: 'お問い合わせ',
                  url: 'https://docs.google.com/forms/d/e/1FAIpQLSfC07B7amecHg9ADznRxjbET2gAqhf49W_LebXUP-F_jYVOug/viewform',
                ),
                _urlCard(
                  context,
                  icon: Icons.article,
                  title: '利用規約',
                  url: 'https://www.kiyac.app/privacypolicy/sBvSLzCgPJ3B7JeCjQOA',
                ),
              ],
            ),
            const SizedBox(height: 24), // 間隔を調整
            const Text(
              '基本設定',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true, // リストビューの高さをコンテンツに合わせる
              physics: NeverScrollableScrollPhysics(), // スクロールを無効化
              children: [
                _toggleThemeCard(ref, isDarkTheme),
                _notificationSettingCard(ref, isNotificationEnabled),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _urlCard(BuildContext context,{required IconData icon, required String title, required String url}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(url: url),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleThemeCard(WidgetRef ref, bool isDarkTheme) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.brightness_6, size: 32),
            const SizedBox(width: 16),
            const Text(
              'ライトテーマ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationSettingCard(WidgetRef ref, bool isNotificationEnabled) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.notifications, size: 32),
            const SizedBox(width: 16),
            const Text(
              '通知設定',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Switch(
              value: isNotificationEnabled,
              onChanged: (value) {
                ref.read(notificationProvider.notifier).toggleNotification();
              },
            ),
          ],
        ),
      ),
    );
  }
}