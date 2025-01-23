import 'package:flutter/material.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/widgets/launch_item.dart';

class LaunchListWidget extends StatelessWidget {
  final List<SpaceXLaunch> launches;
  final Function(SpaceXLaunch) onLaunchTap;
  final Future<void> Function() onRefresh;

  const LaunchListWidget({
    Key? key,
    required this.launches,
    required this.onLaunchTap,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          itemCount: launches.length,
          itemBuilder: (context, index) {
            final launch = launches[index];
            return LaunchItem(
              launch: launch,
              onTap: () => onLaunchTap(launch),
            );
          },
        ),
      ),
    );
  }
}