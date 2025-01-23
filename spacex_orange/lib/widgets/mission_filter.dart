import 'package:spacex_orange/models/mission.dart';

class MissionFilter {
  static List<Mission> filterAndSort({
    required List<Mission> missions,
    required String query,
    required bool sortAscending,
  }) {
    // Filter by mission name
    final filteredMissions = missions.where((mission) {
      return mission.missionName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Sort by mission name
    filteredMissions.sort((a, b) {
      return sortAscending
          ? a.missionName.compareTo(b.missionName)
          : b.missionName.compareTo(a.missionName);
    });

    return filteredMissions;
  }
}