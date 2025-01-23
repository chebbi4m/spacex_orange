import 'package:flutter/material.dart';
import 'package:spacex_orange/models/history.dart';
import 'package:spacex_orange/services/spacex_service.dart';

class HistoryProvider with ChangeNotifier {
  final SpaceXService _spaceXService = SpaceXService();
  List<History> _history = [];
  bool _isLoading = false;
  String? _error;

  List<History> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _history = await _spaceXService.getHistory();
      _error = null;
    } catch (e) {
      _error = 'Failed to load history: $e';
      _history = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}