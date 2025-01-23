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

  Map<String, dynamic> toMap() {
    return {
      'missionName': missionName,
      'missionId': missionId,
      'manufacturers': manufacturers,
      'payloadIds': payloadIds,
      'wikipedia': wikipedia,
      'website': website,
      'twitter': twitter,
      'description': description,
    };
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      missionName: map['missionName'],
      missionId: map['missionId'],
      manufacturers: List<String>.from(map['manufacturers']),
      payloadIds: List<String>.from(map['payloadIds']),
      wikipedia: map['wikipedia'],
      website: map['website'],
      twitter: map['twitter'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mission_name': missionName,
      'mission_id': missionId,
      'manufacturers': manufacturers,
      'payload_ids': payloadIds,
      'wikipedia': wikipedia,
      'website': website,
      'twitter': twitter,
      'description': description,
    };
  }
}