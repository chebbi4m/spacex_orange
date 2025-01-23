import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacex_orange/models/launch.dart';

class SpaceXService {
  final String baseUrl = 'https://api.spacexdata.com/v4/launches';

  Future<List<SpaceXLaunch>> getLaunches({bool forceRefresh = false}) async {


    try {
      final response = await http.get(Uri.parse('$baseUrl?limit=10'));

      if (response.statusCode == 200) {
        final List<dynamic> launchesJson = jsonDecode(response.body);
        final launches = launchesJson.map((json) => SpaceXLaunch.fromJson(json)).toList();

        return launches;
      } else {
        throw Exception('Failed to load SpaceX launches');
      }
    } catch (e) {
      throw Exception('Failed to load SpaceX launches and no cached data available');
    }
  }

  Future<SpaceXLaunch> getLaunchById(String id) async {

    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final launch = SpaceXLaunch.fromJson(json);
        

        return launch;
      } else {
        throw Exception('Failed to load SpaceX launch');
      }
    } catch (e) {
      throw Exception('Failed to load SpaceX launch ');
    }
  }
}

