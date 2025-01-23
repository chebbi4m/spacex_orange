import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:spacex_orange/models/mission.dart';
import '../services/spacex_service.dart';

class MissionProvider with ChangeNotifier {
  final SpaceXService _spaceXService = SpaceXService();
  List<Mission> _missions = [];
  Mission? _selectedMission;
  bool _isLoading = false;
  bool _isLoadingMore = false; // For pagination
  String? _error;
  bool _isOffline = false;
  int _skip = 0; // Pagination offset
  final int _take = 10; // Number of items to fetch per request

  List<Mission> get missions => _missions;
  Mission? get selectedMission => _selectedMission;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore; // For pagination
  String? get error => _error;
  bool get isOffline => _isOffline;

  Future<void> fetchMissions({bool forceRefresh = false}) async {
  if (forceRefresh) {
    _skip = 0; // Reset skip when forcing a refresh
    _missions = []; // Clear existing missions
  }

  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    // Check internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _isOffline = true;
      _missions = await _spaceXService.getMissions();
    } else {
      _isOffline = false;
      final newMissions = await _spaceXService.getMissions();
      _missions.addAll(newMissions); // Append new missions to the list
    }
    _error = null;
  } catch (e) {
    _error = 'Failed to load missions: $e';
    _missions = [];
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> loadMoreMissions() async {
    if (_isLoadingMore) return; // Prevent multiple simultaneous requests

    _isLoadingMore = true;
    notifyListeners();

    try {
      _skip += _take; // Increment skip for pagination
      final newMissions = await _spaceXService.getMissions();
      _missions.addAll(newMissions); // Append new missions to the list
    } catch (e) {
      _error = 'Failed to load more missions.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchMissionDetails(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedMission = await _spaceXService.getMissionById(id);
      _error = null;
    } catch (e) {
      _error = 'Failed to load mission details.';
      _selectedMission = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedMission() {
    _selectedMission = null;
    notifyListeners();
  }
}