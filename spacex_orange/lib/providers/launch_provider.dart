import 'package:flutter/foundation.dart';
import 'package:spacex_orange/models/launch.dart';
import '../services/spacex_service.dart';

class SpaceXProvider with ChangeNotifier {
  final SpaceXService _spaceXService = SpaceXService();
  List<SpaceXLaunch> _launches = [];
  SpaceXLaunch? _selectedLaunch;
  bool _isLoading = false;
  String? _error;

  List<SpaceXLaunch> get launches => _launches;
  SpaceXLaunch? get selectedLaunch => _selectedLaunch;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLaunches({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _launches = await _spaceXService.getLaunches(forceRefresh: forceRefresh);
      _error = null;
    } catch (e) {
      _error = 'Failed to load SpaceX launches.';
      _launches = [];
    } finally {
      _isLoading = false;
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

