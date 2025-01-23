import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacex_orange/helpers/database_helper.dart';
import 'package:spacex_orange/models/launch.dart';

class SpaceXService {
  final String baseUrl = 'https://api.spacexdata.com/v4/launches';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<SpaceXLaunch>> getLaunches({bool forceRefresh = false}) async {

    if (!forceRefresh) {
      final cachedLaunches = await _dbHelper.getLaunches();
      if (cachedLaunches.isNotEmpty) {
        return cachedLaunches;
      }
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl?limit=10'));

      if (response.statusCode == 200) {
        final List<dynamic> launchesJson = jsonDecode(response.body);
        final launches = launchesJson.map((json) => SpaceXLaunch.fromJson(json)).toList();

        for (final launch in launches) {
          await _dbHelper.insertLaunch(launch);
        }

        return launches;
      } else {
        print("aaaa");
        throw Exception('Failed to load SpaceX launches');
      }
    } catch (e) {

      final cachedLaunches = await _dbHelper.getLaunches();
      if (cachedLaunches.isNotEmpty) {
        return cachedLaunches;
      } else {
        throw Exception('Failed to load SpaceX launches and no cached data available');
      }
    }
  }

  Future<SpaceXLaunch> getLaunchById(String id) async {

    final cachedLaunches = await _dbHelper.getLaunches();
  final cachedLaunch = cachedLaunches.firstWhere(
    (launch) => launch.id == id,
  );

  if (cachedLaunch != null) {
    return cachedLaunch;
  }


    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final launch = SpaceXLaunch.fromJson(json);

        await _dbHelper.insertLaunch(launch);

        return launch;
      } else {
        throw Exception('Failed to load SpaceX launch');
      }
    } catch (e) {
      throw Exception('Failed to load SpaceX launch');
    }
  }
}