import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:spacex_orange/providers/history_provider.dart';
import 'package:spacex_orange/providers/launch_provider.dart';
import 'package:spacex_orange/providers/mission_provider.dart';
import 'package:spacex_orange/screens/home_page.dart';
import 'package:spacex_orange/screens/offline_mode_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceXProvider()),
        ChangeNotifierProvider(create: (context) => MissionProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
      ],
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
        scaffoldBackgroundColor: Colors.black,
      ),
      home: FutureBuilder<ConnectivityResult>(
        future: Connectivity().checkConnectivity(),
        builder: (context, snapshot) {
          
            // Navigate to the appropriate page based on connectivity
            if (snapshot.data == ConnectivityResult.none) {
              return const OfflineModePage();
            } else {
              return const MainPage();
            }
          
        },
      ),
    );
  }
}