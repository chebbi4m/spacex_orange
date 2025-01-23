import 'package:flutter/material.dart';
import 'package:spacex_orange/screens/history_page.dart';
import 'package:spacex_orange/screens/launches_page.dart';
import 'package:spacex_orange/screens/missions_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    LaunchesPage(),
    MissionsPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'Launches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Missions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'History',
          ),
        ],
      ),
    );
  }
}