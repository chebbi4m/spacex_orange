import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:spacex_orange/models/launch.dart';
import '../services/spacex_service.dart';

class SpaceXProvider with ChangeNotifier {
  final SpaceXService _spaceXService = SpaceXService();
  List<SpaceXLaunch> _launches = [];
  SpaceXLaunch? _selectedLaunch;
  bool _isLoading = false;
  bool _isLoadingMore = false; // For pagination
  String? _error;
  bool _isOffline = false;
  int _skip = 0; // Pagination offset
  final int _take = 10; // Number of items to fetch per request

  List<SpaceXLaunch> get launches => _launches;
  SpaceXLaunch? get selectedLaunch => _selectedLaunch;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore; // For pagination
  String? get error => _error;
  bool get isOffline => _isOffline;

  Future<void> fetchLaunches({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _skip = 0; // Reset skip when forcing a refresh
      _launches = []; // Clear existing launches
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check internet connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _isOffline = true;
        _launches = await _spaceXService.getLaunches(skip: _skip, take: _take);
      } else {
        _isOffline = false;
        final newLaunches = await _spaceXService.getLaunches(skip: _skip, take: _take);
        _launches.addAll(newLaunches); // Append new launches to the list
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to load SpaceX launches.';
      _launches = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreLaunches() async {
    if (_isLoadingMore) return; // Prevent multiple simultaneous requests

    _isLoadingMore = true;
    notifyListeners();

    try {
      _skip += _take; // Increment skip for pagination
      final newLaunches = await _spaceXService.getLaunches(skip: _skip, take: _take);
      _launches.addAll(newLaunches); // Append new launches to the list
    } catch (e) {
      _error = 'Failed to load more SpaceX launches.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchLaunchDetails(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedLaunch = await _spaceXService.getLaunchById(id);
      _error = null;
    } catch (e) {
      _error = 'Failed to load launch details.';
      _selectedLaunch = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedLaunch() {
    _selectedLaunch = null;
    notifyListeners();
  }
}