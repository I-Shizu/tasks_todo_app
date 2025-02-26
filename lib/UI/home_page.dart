import 'package:flutter/material.dart';

import '../UI/add_task_screen.dart';
import '../UI/calendar_screen.dart';
import '../UI/setting_screen.dart';
import '../UI/task_list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CalendarScreen(),
    TaskListScreen(),
    AddTaskScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "今日のスケジュール";
      case 1:
        return "タスク一覧";
      case 2:
        return "タスク追加";
      case 3:
        return "設定";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex)),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '今日',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '追加',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}