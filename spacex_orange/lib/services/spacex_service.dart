import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacex_orange/helpers/database_helper.dart';
import 'package:spacex_orange/models/launch.dart';

class SpaceXService {
  final String baseUrl = 'https://api.spacexdata.com/v4/launches';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<SpaceXLaunch>> getLaunches({int skip = 0, int take = 10}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?limit=$take&offset=$skip'));

      if (response.statusCode == 200) {
        final List<dynamic> launchesJson = jsonDecode(response.body);
        final launches = launchesJson.map((json) => SpaceXLaunch.fromJson(json)).toList();

        // Save launches to the database
        for (final launch in launches) {
          await _dbHelper.insertLaunch(launch);
        }

        return launches;
      } else {
        throw Exception('Failed to load SpaceX launches: ${response.statusCode}');
      }
    } catch (e) {
      // If API call fails, return cached data (if available)
      final cachedLaunches = await _dbHelper.getLaunches();
      if (cachedLaunches.isNotEmpty) {
        return cachedLaunches;
      } else {
        throw Exception('Failed to load SpaceX launches and no cached data available: $e');
      }
    }
  }

  Future<SpaceXLaunch> getLaunchById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final launch = SpaceXLaunch.fromJson(json);

        // Save the launch to the database
        await _dbHelper.insertLaunch(launch);

        return launch;
      } else {
        throw Exception('Failed to load SpaceX launch: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load SpaceX launch: $e');
    }
  }
}