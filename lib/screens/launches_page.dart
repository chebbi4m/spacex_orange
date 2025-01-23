import 'package:flutter/material.dart';
import 'package:project/providers/launch_provider.dart';
import 'package:provider/provider.dart';
import 'package:project/models/launch.dart';

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
      Provider.of<SpaceXProvider>(context, listen: false).fetchLaunches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launches'),
      ),
      body: Consumer<SpaceXProvider>(
        builder: (context, spaceXProvider, child) {
          if (spaceXProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (spaceXProvider.error != null) {
            return Center(child: Text(spaceXProvider.error!));
          } else {
            return RefreshIndicator(
              onRefresh: () => spaceXProvider.fetchLaunches(forceRefresh: true),
              child: ListView.builder(
                itemCount: spaceXProvider.launches.length,
                itemBuilder: (context, index) {
                  final launch = spaceXProvider.launches[index];
                  return LaunchListItem(launch: launch);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class LaunchListItem extends StatelessWidget {
  final SpaceXLaunch launch;

  const LaunchListItem({Key? key, required this.launch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(launch.missionName),
      subtitle: Text('Date: ${launch.launchDate}\nRocket: ${launch.rocketName}'),
      onTap: () {
        // TODO: Implement navigation to launch details page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on ${launch.missionName}')),
        );
      },
    );
  }
}