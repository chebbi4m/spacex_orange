import 'package:spacex_orange/models/history.dart';

class HistoryFilter {
  static List<History> filterAndSort({
    required List<History> history,
    required String query,
    required bool sortAscending,
  }) {
    // Filter by search query
    final filteredHistory = history.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()) ||
             event.details.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Sort by date
    filteredHistory.sort((a, b) {
      final dateA = DateTime.parse(a.eventDateUtc);
      final dateB = DateTime.parse(b.eventDateUtc);
      return sortAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    return filteredHistory;
  }
}