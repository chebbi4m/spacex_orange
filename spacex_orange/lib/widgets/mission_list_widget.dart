import 'package:flutter/material.dart';
import 'package:spacex_orange/models/mission.dart';
import 'package:spacex_orange/screens/missions_page.dart';
import 'package:spacex_orange/widgets/mission_item.dart';

class MissionListWidget extends StatelessWidget {
  final List<Mission> missions;
  final Function(Mission) onMissionTap;
  final Future<void> Function() onRefresh;

  const MissionListWidget({
    Key? key,
    required this.missions,
    required this.onMissionTap,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          itemCount: missions.length,
          itemBuilder: (context, index) {
            final mission = missions[index];
            return MissionItem(
              mission: mission,
              onTap: () => onMissionTap(mission),
            );
          },
        ),
      ),
    );
  }
}