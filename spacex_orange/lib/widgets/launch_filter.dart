import 'package:flutter/material.dart';


class SearchAndSortWidget extends StatelessWidget {
  final TextEditingController searchController;
  final bool sortAscending;
  final VoidCallback onSortChanged;

  const SearchAndSortWidget({
    Key? key,
    required this.searchController,
    required this.sortAscending,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search launches...',
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
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Sort by Date:',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              IconButton(
                icon: Icon(
                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                ),
                onPressed: onSortChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}