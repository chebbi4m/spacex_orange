import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/models/history.dart';
import 'package:spacex_orange/providers/history_provider.dart';
import 'package:spacex_orange/screens/history_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
      historyProvider.fetchHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<History> _filterAndSortHistory(List<History> history, String query, bool sortAscending) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, child) {
          if (historyProvider.isLoading && historyProvider.history.isEmpty) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
          } else if (historyProvider.error != null) {
            return Center(child: Text(historyProvider.error!, style: const TextStyle(color: Colors.red)));
          } else {
            final filteredHistory = _filterAndSortHistory(
              historyProvider.history,
              _searchController.text,
              _sortAscending,
            );

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'SpaceX History',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue[900]!, Colors.black],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.history, size: 100, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search history...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: const Icon(Icons.search, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                          ),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (query) {
                            setState(() {}); // Rebuild the UI when the search query changes
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Sort by Date:',
                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                            ),
                            IconButton(
                              icon: Icon(
                                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _sortAscending = !_sortAscending; // Toggle sort order
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = filteredHistory[index];
                      return HistoryItem(
                        event: event,
                        onTap: () => _navigateToHistoryDetails(context, event),
                      );
                    },
                    childCount: filteredHistory.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _navigateToHistoryDetails(BuildContext context, History event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoryDetailsPage(event: event),
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final History event;
  final VoidCallback onTap;

  const HistoryItem({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'history-${event.id}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${event.eventDateUtc}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}