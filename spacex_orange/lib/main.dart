import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/providers/launch_provider.dart';
import 'package:spacex_orange/screens/launches_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SpaceXProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceX Launches',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LaunchesPage(),
    );
  }
}