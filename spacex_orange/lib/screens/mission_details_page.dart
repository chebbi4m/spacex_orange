import 'package:flutter/material.dart';
import 'package:spacex_orange/models/mission.dart';

class MissionDetailsPage extends StatelessWidget {
  final Mission mission;

  const MissionDetailsPage({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                mission.missionName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              background: Hero(
                tag: 'mission-${mission.missionId}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue[900]!, Colors.black],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.rocket, size: 100, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.fingerprint, 'Mission ID', mission.missionId),
                      _buildInfoRow(Icons.business, 'Manufacturers', mission.manufacturers.join(", ")),
                      _buildInfoRow(Icons.inventory_2, 'Payload IDs', mission.payloadIds.join(", ")),
                      _buildInfoRow(Icons.language, 'Wikipedia', mission.wikipedia),
                      _buildInfoRow(Icons.web, 'Website', mission.website),
                      _buildInfoRow(Icons.chat, 'Twitter', mission.twitter),
                      _buildInfoRow(Icons.description, 'Description', mission.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}