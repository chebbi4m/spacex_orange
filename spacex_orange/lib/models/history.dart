class History {
  final String id;
  final String title;
  final String eventDateUtc;
  final String details;

  History({
    required this.id,
    required this.title,
    required this.eventDateUtc,
    required this.details,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] ?? 'Unknown ID',
      title: json['title'] ?? 'Unknown Title',
      eventDateUtc: json['event_date_utc'] ?? 'Unknown Date',
      details: json['details'] ?? 'No details available',
    );
  }
}