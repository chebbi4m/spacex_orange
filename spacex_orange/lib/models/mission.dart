class Mission {
  final String missionName;
  final String missionId;
  final List<String> manufacturers;
  final List<String> payloadIds;
  final String wikipedia;
  final String website;
  final String twitter;
  final String description;

  Mission({
    required this.missionName,
    required this.missionId,
    required this.manufacturers,
    required this.payloadIds,
    required this.wikipedia,
    required this.website,
    required this.twitter,
    required this.description,
  });

  // Convert JSON to Mission object
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      missionName: json['mission_name'] ?? 'Unknown Mission',
      missionId: json['mission_id'] ?? 'Unknown ID',
      manufacturers: List<String>.from(json['manufacturers'] ?? []),
      payloadIds: List<String>.from(json['payload_ids'] ?? []),
      wikipedia: json['wikipedia'] ?? '',
      website: json['website'] ?? '',
      twitter: json['twitter'] ?? '',
      description: json['description'] ?? 'No details available',
    );
  }

  // Convert Mission object to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'missionName': missionName,
      'missionId': missionId,
      'manufacturers': manufacturers.join(','), // Serialize List<String> to String
      'payloadIds': payloadIds.join(','), // Serialize List<String> to String
      'wikipedia': wikipedia,
      'website': website,
      'twitter': twitter,
      'description': description,
    };
  }

  // Convert Map (from database) to Mission object
  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      missionName: map['missionName'],
      missionId: map['missionId'],
      manufacturers: map['manufacturers'].split(','), // Deserialize String to List<String>
      payloadIds: map['payloadIds'].split(','), // Deserialize String to List<String>
      wikipedia: map['wikipedia'],
      website: map['website'],
      twitter: map['twitter'],
      description: map['description'],
    );
  }
}