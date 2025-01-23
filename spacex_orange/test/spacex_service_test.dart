import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:spacex_orange/models/history.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/models/mission.dart';
import 'package:spacex_orange/services/spacex_service.dart';
import 'mocks.dart';
import 'mocks.mocks.dart';

void main() {
  late SpaceXService spaceXService;
  late MockClient mockHttpClient;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockHttpClient = MockClient();
    mockDatabaseHelper = MockDatabaseHelper();
    spaceXService = SpaceXService(client: mockHttpClient, dbHelper: mockDatabaseHelper);
  });

  group('getLaunches', () {
    test('returns a list of launches when the API call is successful', () async {
      // Mock API response
      when(mockHttpClient.get(Uri.parse('https://api.spacexdata.com/v4/launches')))
          .thenAnswer((_) async => http.Response(
                '''
                [
                  {
                    "id": "1",
                    "name": "Test Launch",
                    "date_utc": "2023-10-01T00:00:00.000Z",
                    "rocket": "Test Rocket",
                    "details": "Test Details"
                  }
                ]
                ''',
                200,
              ));

      // Mock database insert
      when(mockDatabaseHelper.insertLaunch(any)).thenAnswer((_) async => 1);

      // Mock database getLaunches
      when(mockDatabaseHelper.getLaunches()).thenAnswer((_) async => []);

      // Call the method
      final launches = await spaceXService.getLaunches();

      // Verify the result
      expect(launches, isA<List<SpaceXLaunch>>());
      expect(launches.length, 1); // Ensure the list has exactly one item
      expect(launches[0].missionName, 'Test Launch');
    });

    test('throws an exception when the API call fails', () async {
      // Mock API failure
      when(mockHttpClient.get(Uri.parse('https://api.spacexdata.com/v4/launches')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Mock database getLaunches
      when(mockDatabaseHelper.getLaunches()).thenAnswer((_) async => []);

      // Call the method and expect an exception
      expect(() => spaceXService.getLaunches(), throwsException);
    });
  });

  group('getMissions', () {
    test('returns a list of missions when the API call is successful', () async {
      // Mock API response
      when(mockHttpClient.get(Uri.parse('https://api.spacexdata.com/v3/missions')))
          .thenAnswer((_) async => http.Response(
                '''
                [
                  {
                    "mission_name": "Test Mission",
                    "mission_id": "1",
                    "manufacturers": ["Test Manufacturer"],
                    "payload_ids": ["Test Payload"],
                    "wikipedia": "https://example.com",
                    "website": "https://example.com",
                    "twitter": "https://twitter.com",
                    "description": "Test Description"
                  }
                ]
                ''',
                200,
              ));

      // Mock database insert
      when(mockDatabaseHelper.insertMission(any)).thenAnswer((_) async => 1);

      // Mock database getMissions
      when(mockDatabaseHelper.getMissions()).thenAnswer((_) async => []);

      // Call the method
      final missions = await spaceXService.getMissions();

      // Verify the result
      expect(missions, isA<List<Mission>>());
      expect(missions.length, 1); // Ensure the list has exactly one item
      expect(missions[0].missionName, 'Test Mission');
    });

    test('throws an exception when the API call fails', () async {
      // Mock API failure
      when(mockHttpClient.get(Uri.parse('https://api.spacexdata.com/v3/missions')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Mock database getMissions
      when(mockDatabaseHelper.getMissions()).thenAnswer((_) async => []);

      // Call the method and expect an exception
      expect(() => spaceXService.getMissions(), throwsException);
    });
  });

  group('getHistory', () {
    test('returns a list of history events when the API call is successful', () async {
      // Mock API response
      when(mockHttpClient.get(Uri.parse('https://api.spacexdata.com/v4/history')))
          .thenAnswer((_) async => http.Response(
                '''
                [
                  {
                    "id": "1",
                    "title": "Test Event",
                    "event_date_utc": "2023-10-01T00:00:00.000Z",
                    "details": "Test Details"
                  }
                ]
                ''',
                200,
              ));

      // Mock database insert
      when(mockDatabaseHelper.insertHistory(any)).thenAnswer((_) async => 1);

      // Mock database getHistory
      when(mockDatabaseHelper.getHistory()).thenAnswer((_) async => []);

      // Call the method
      final history = await spaceXService.getHistory();

      // Verify the result
      expect(history, isA<List<History>>());
      expect(history.length, 1); // Ensure the list has exactly one item
      expect(history[0].title, 'Test Event');
    });

    test('throws an exception when the API call fails', () async {
      // Mock API failure
      when(mockHttpClient.get(Uri.parse('https://api.spacexdata.com/v4/history')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Mock database getHistory
      when(mockDatabaseHelper.getHistory()).thenAnswer((_) async => []);

      // Call the method and expect an exception
      expect(() => spaceXService.getHistory(), throwsException);
    });
  });
}