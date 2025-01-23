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

  // Convert JSON to History object
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] ?? 'Unknown ID',
      title: json['title'] ?? 'Unknown Title',
      eventDateUtc: json['event_date_utc'] ?? 'Unknown Date',
      details: json['details'] ?? 'No details available',
    );
  }

  // Convert History object to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'eventDateUtc': eventDateUtc,
      'details': details,
    };
  }

  // Convert Map (from database) to History object
  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'],
      title: map['title'],
      eventDateUtc: map['eventDateUtc'],
      details: map['details'],
    );
  }
}