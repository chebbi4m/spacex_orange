import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/models/history.dart';
import 'package:spacex_orange/providers/history_provider.dart';
import 'package:spacex_orange/widgets/history_details_page.dart';
import 'package:spacex_orange/widgets/history_filter.dart';
import 'package:spacex_orange/widgets/history_item.dart';
import 'package:spacex_orange/widgets/history_list_widget.dart'; // Import the new widget

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
    _fetchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchHistory() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
      historyProvider.fetchHistory();
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  void _navigateToHistoryDetails(BuildContext context, History event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoryDetailsPage(event: event),
      ),
    );
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
            final filteredHistory = HistoryFilter.filterAndSort(
              history: historyProvider.history,
              query: _searchController.text,
              sortAscending: _sortAscending,
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
                              onPressed: _toggleSortOrder,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                HistoryListWidget(
                  history: filteredHistory,
                  onHistoryTap: (event) => _navigateToHistoryDetails(context, event),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}