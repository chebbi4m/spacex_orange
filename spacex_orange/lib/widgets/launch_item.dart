import 'package:flutter/material.dart';
import 'package:spacex_orange/models/launch.dart';


class LaunchItem extends StatelessWidget {
  final SpaceXLaunch launch;
  final VoidCallback onTap;

  const LaunchItem({
    Key? key,
    required this.launch,
    required this.onTap,
  }) : super(key: key);

  // Helper function to format the date
  String _formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final month = _getMonthName(dateTime.month); // Get month name
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12; // Convert to 12-hour format
    final minute = dateTime.minute.toString().padLeft(2, '0'); // Add leading zero if needed
    final period = dateTime.hour < 12 ? 'AM' : 'PM'; // Determine AM/PM

    return '$month $day, $year - $hour:$minute $period';
  }

  // Helper function to get the month name
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the launch date
    final formattedDate = _formatDate(launch.launchDate);

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
                        'Date: $formattedDate', // Use the formatted date here
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