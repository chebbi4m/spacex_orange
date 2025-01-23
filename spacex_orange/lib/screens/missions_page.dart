import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/models/mission.dart';
import 'package:spacex_orange/providers/mission_provider.dart';
import 'package:spacex_orange/screens/mission_details_page.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final missionProvider = Provider.of<MissionProvider>(context, listen: false);
      missionProvider.fetchMissions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Mission> _filterAndSortMissions(List<Mission> missions, String query, bool sortAscending) {
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
            final filteredMissions = _filterAndSortMissions(
              missionProvider.missions,
              _searchController.text,
              _sortAscending,
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

  void _navigateToMissionDetails(BuildContext context, Mission mission) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MissionDetailsPage(mission: mission),
      ),
    );
  }
}

class MissionItem extends StatelessWidget {
  final Mission mission;
  final VoidCallback onTap;

  const MissionItem({
    Key? key,
    required this.mission,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'mission-${mission.missionId}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.rocket_launch, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.missionName,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}