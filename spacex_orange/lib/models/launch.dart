class SpaceXLaunch {
  final String id;
  final String missionName;
  final String launchDate;
  final String rocketName;
  final String details;

  SpaceXLaunch({
    required this.id,
    required this.missionName,
    required this.launchDate,
    required this.rocketName,
    required this.details,
  });

  factory SpaceXLaunch.fromJson(Map<String, dynamic> json) {
    return SpaceXLaunch(
      id: json['id'] ?? '',
      missionName: json['name'] ?? 'Unknown Mission',
      launchDate: json['date_utc'] ?? 'Unknown Date',
      rocketName: json['rocket'] is String ? json['rocket'] : (json['rocket']['name'] ?? 'Unknown Rocket'), // Handle rocket object
      details: json['details'] ?? 'No details available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': missionName,
      'launchDate': launchDate,
      'rocketName': rocketName,
      'details': details,
    };
  }

  factory SpaceXLaunch.fromMap(Map<String, dynamic> map) {
    return SpaceXLaunch(
      id: map['id'],
      missionName: map['name'],
      launchDate: map['launchDate'],
      rocketName: map['rocketName'],
      details: map['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': missionName,
      'launchDate': launchDate,
      'rocketName': rocketName,
      'details': details,
    };
  }
}