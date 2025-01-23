import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/providers/launch_provider.dart';
import 'package:spacex_orange/screens/launch_details_page.dart';
import 'package:spacex_orange/widgets/LaunchListWidget.dart';
import 'package:spacex_orange/widgets/search_and_sort.dart';

class LaunchesPage extends StatefulWidget {
  const LaunchesPage({Key? key}) : super(key: key);

  @override
  _LaunchesPageState createState() => _LaunchesPageState();
}

class _LaunchesPageState extends State<LaunchesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final spaceXProvider = Provider.of<SpaceXProvider>(context, listen: false);
      spaceXProvider.fetchLaunches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SpaceXLaunch> _filterAndSortLaunches(List<SpaceXLaunch> launches, String query, bool sortAscending) {
    // Filter by search query
    final filteredLaunches = launches.where((launch) {
      return launch.missionName.toLowerCase().contains(query.toLowerCase()) ||
             launch.details.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Sort by date
    filteredLaunches.sort((a, b) {
      final dateA = DateTime.parse(a.launchDate);
      final dateB = DateTime.parse(b.launchDate);
      return sortAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    return filteredLaunches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('SpaceX Launches', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<SpaceXProvider>(
        builder: (context, spaceXProvider, child) {
          if (spaceXProvider.isLoading && spaceXProvider.launches.isEmpty) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
          } else if (spaceXProvider.error != null) {
            return Center(child: Text(spaceXProvider.error!, style: const TextStyle(color: Colors.red)));
          } else {
            final filteredLaunches = _filterAndSortLaunches(
              spaceXProvider.launches,
              _searchController.text,
              _sortAscending,
            );

            return Column(
              children: [
                SearchAndSortWidget(
                  searchController: _searchController,
                  sortAscending: _sortAscending,
                  onSortChanged: () {
                    setState(() {
                      _sortAscending = !_sortAscending;
                    });
                  },
                ),
                LaunchListWidget(
                  launches: filteredLaunches,
                  onLaunchTap: (launch) => _navigateToLaunchDetails(context, launch),
                  onRefresh: () => spaceXProvider.fetchLaunches(forceRefresh: true),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _navigateToLaunchDetails(BuildContext context, SpaceXLaunch launch) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LaunchDetailsPage(launch: launch),
      ),
    );
  }
}