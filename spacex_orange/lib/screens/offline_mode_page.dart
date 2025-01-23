import 'package:flutter/material.dart';
import 'dart:async';

import 'package:spacex_orange/screens/launches_page.dart';

class OfflineModePage extends StatefulWidget {
  const OfflineModePage({Key? key}) : super(key: key);

  @override
  _OfflineModePageState createState() => _OfflineModePageState();
}

class _OfflineModePageState extends State<OfflineModePage> {
  @override
  void initState() {
    super.initState();
    _redirectAfterDelay();
  }

  void _redirectAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LaunchesPage(),
      ),
    );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Activating Offline Mode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}