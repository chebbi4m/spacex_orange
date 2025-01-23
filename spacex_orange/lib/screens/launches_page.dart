import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/providers/launch_provider.dart';
import 'package:spacex_orange/screens/launch_details_page.dart';
import 'package:spacex_orange/screens/offline_mode_page.dart';

class LaunchesPage extends StatefulWidget {
  const LaunchesPage({Key? key}) : super(key: key);

  @override
  _LaunchesPageState createState() => _LaunchesPageState();
}

class _LaunchesPageState extends State<LaunchesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final spaceXProvider = Provider.of<SpaceXProvider>(context, listen: false);
      spaceXProvider.fetchLaunches();
    });
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
            return Column(
              children: [

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => spaceXProvider.fetchLaunches(forceRefresh: true),
                    child: ListView.builder(
                      itemCount: spaceXProvider.launches.length,
                      itemBuilder: (context, index) {
                        final launch = spaceXProvider.launches[index];
                        return LaunchItem(
                          launch: launch,
                          onTap: () => _navigateToLaunchDetails(context, launch),
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

  void _navigateToLaunchDetails(BuildContext context, SpaceXLaunch launch) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LaunchDetailsPage(launch: launch),
      ),
    );
  }
}

class LaunchItem extends StatelessWidget {
  final SpaceXLaunch launch;
  final VoidCallback onTap;

  const LaunchItem({
    Key? key,
    required this.launch,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'launch-${launch.id}',
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
                        launch.missionName,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${launch.launchDate}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rocket: ${launch.rocketName}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
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