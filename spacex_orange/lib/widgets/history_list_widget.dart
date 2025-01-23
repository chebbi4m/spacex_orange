import 'package:flutter/material.dart';
import 'package:spacex_orange/models/history.dart';
import 'package:spacex_orange/widgets/history_item.dart';

class HistoryListWidget extends StatelessWidget {
  final List<History> history;
  final Function(History) onHistoryTap;

  const HistoryListWidget({
    Key? key,
    required this.history,
    required this.onHistoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final event = history[index];
          return HistoryItem(
            event: event,
            onTap: () => onHistoryTap(event),
          );
        },
        childCount: history.length,
      ),
    );
  }
}