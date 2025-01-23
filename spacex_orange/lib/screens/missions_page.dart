import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/models/mission.dart';
import 'package:spacex_orange/providers/mission_provider.dart';
import 'package:spacex_orange/widgets/mission_details_page.dart';
import 'package:spacex_orange/widgets/mission_filter.dart';
import 'package:spacex_orange/widgets/mission_item.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({Key? key}) : super(key: key);

  @override
  _MissionsPageState createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchMissions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final missionProvider = Provider.of<MissionProvider>(context, listen: false);
      missionProvider.fetchMissions();
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  void _navigateToMissionDetails(BuildContext context, Mission mission) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MissionDetailsPage(mission: mission),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('SpaceX Missions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<MissionProvider>(
        builder: (context, missionProvider, child) {
          if (missionProvider.isLoading && missionProvider.missions.isEmpty) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
          } else if (missionProvider.error != null) {
            return Center(child: Text(missionProvider.error!, style: const TextStyle(color: Colors.red)));
          } else {
            final filteredMissions = MissionFilter.filterAndSort(
              missions: missionProvider.missions,
              query: _searchController.text,
              sortAscending: _sortAscending,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search missions by name...',
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
                            'Sort by Name:',
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
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => missionProvider.fetchMissions(forceRefresh: true),
                    child: ListView.builder(
                      itemCount: filteredMissions.length,
                      itemBuilder: (context, index) {
                        final mission = filteredMissions[index];
                        return MissionItem(
                          mission: mission,
                          onTap: () => _navigateToMissionDetails(context, mission),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}