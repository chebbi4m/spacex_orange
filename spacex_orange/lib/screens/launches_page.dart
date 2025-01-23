import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/providers/launch_provider.dart';

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
                  return LaunchItem(
                    launch: launch,
                    onTap: () => _showLaunchDetails(context, launch),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _showLaunchDetails(BuildContext context, SpaceXLaunch launch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(launch.missionName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Date: ${launch.launchDate}'),
                const SizedBox(height: 8),
                Text('Rocket: ${launch.rocketName}'),
                const SizedBox(height: 8),
                Text('Details: ${launch.details}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                launch.missionName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${launch.launchDate}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Rocket: ${launch.rocketName}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}