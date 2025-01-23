import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacex_orange/helpers/database_helper.dart';
import 'package:spacex_orange/models/history.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/models/mission.dart';

class SpaceXService {
  final String baseUrl = 'https://api.spacexdata.com/v4';
  final DatabaseHelper _dbHelper;

  // Add a field for http.Client
  http.Client httpClient;

  // Constructor to allow dependency injection
  SpaceXService({DatabaseHelper? dbHelper, http.Client? client})
      : _dbHelper = dbHelper ?? DatabaseHelper(),
        httpClient = client ?? http.Client();


  Future<List<SpaceXLaunch>> getLaunches({int skip = 0, int take = 10}) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/launches'));

    if (response.statusCode == 200) {
      final List<dynamic> launchesJson = jsonDecode(response.body);
      final launches = launchesJson.map((json) {
        return SpaceXLaunch(
          id: json['id'] ?? 'Unknown ID', // Use 'id' instead of 'flight_number'
          missionName: json['name'] ?? 'Unknown Mission', // Use 'name' instead of 'mission_name'
          launchDate: json['date_utc'] ?? 'Unknown Date', // Use 'date_utc'
          rocketName: json['rocket'] ?? 'Unknown Rocket', // 'rocket' is a string, not an object
          details: json['details'] ?? 'No details available',
        );
      }).toList();

      // Save launches to the database
      for (final launch in launches) {
        await _dbHelper.insertLaunch(launch);
      }

      return launches;
    } else {
      throw Exception('Failed to load SpaceX launches: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching launches: $e'); // Log the error
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
      final response = await http.get(Uri.parse('$baseUrl/launches/$id'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final launch = SpaceXLaunch(
          id: json['flight_number'].toString(), // Use flight_number as the ID
          missionName: json['mission_name'] ?? 'Unknown Mission',
          launchDate: json['launch_date_utc'] ?? 'Unknown Date',
          rocketName: json['rocket']['rocket_name'] ?? 'Unknown Rocket',
          details: json['details'] ?? 'No details available',
        );

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

  Future<List<Mission>> getMissions() async {
  try {
    final response = await http.get(Uri.parse('https://api.spacexdata.com/v3/missions'));

    if (response.statusCode == 200) {
      final List<dynamic> missionsJson = jsonDecode(response.body);
      final missions = missionsJson.map((json) {
        return Mission(
          missionName: json['mission_name'] ?? 'Unknown Mission',
          missionId: json['mission_id'] ?? 'Unknown ID',
          manufacturers: List<String>.from(json['manufacturers'] ?? []),
          payloadIds: List<String>.from(json['payload_ids'] ?? []),
          wikipedia: json['wikipedia'] ?? '',
          website: json['website'] ?? '',
          twitter: json['twitter'] ?? '',
          description: json['description'] ?? 'No details available',
        );
      }).toList();

      // Save missions to the database
      for (final mission in missions) {
        await _dbHelper.insertMission(mission);
      }

      return missions;
    } else {
      throw Exception('Failed to load missions: ${response.statusCode}');
    }
  } catch (e) {
    // If API call fails, return cached data (if available)
    final cachedMissions = await _dbHelper.getMissions();
    if (cachedMissions.isNotEmpty) {
      return cachedMissions;
    } else {
      throw Exception('Failed to load missions and no cached data available: $e');
    }
  }
}

Future<Mission> getMissionById(String id) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/missions/$id'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final mission = Mission(
        missionName: json['mission_name'] ?? 'Unknown Mission',
        missionId: json['mission_id'] ?? 'Unknown ID',
        manufacturers: List<String>.from(json['manufacturers'] ?? []),
        payloadIds: List<String>.from(json['payload_ids'] ?? []),
        wikipedia: json['wikipedia'] ?? '',
        website: json['website'] ?? '',
        twitter: json['twitter'] ?? '',
        description: json['description'] ?? 'No details available',
      );

      // Save the mission to the database
      await _dbHelper.insertMission(mission);

      return mission;
    } else {
      throw Exception('Failed to load mission: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load mission: $e');
  }
}

  Future<List<History>> getHistory() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/history'));

      if (response.statusCode == 200) {
        final List<dynamic> historyJson = jsonDecode(response.body);
        final history = historyJson.map((json) {
          return History.fromJson(json);
        }).toList();

        // Save history to the database (optional)
        for (final event in history) {
          await _dbHelper.insertHistory(event);
        }

        return history;
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching history: $e');
      // If API call fails, return cached data (if available)
      final cachedHistory = await _dbHelper.getHistory();
      if (cachedHistory.isNotEmpty) {
        return cachedHistory;
      } else {
        throw Exception('Failed to load history and no cached data available: $e');
      }
    }
  }
}