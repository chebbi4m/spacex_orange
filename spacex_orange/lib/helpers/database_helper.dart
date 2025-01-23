import 'package:spacex_orange/models/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/models/mission.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'spacex_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE launches(
      id TEXT PRIMARY KEY,
      name TEXT,
      launchDate TEXT,
      details TEXT,
      rocketName TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE missions(
      missionId TEXT PRIMARY KEY,
      missionName TEXT,
      manufacturers TEXT,
      payloadIds TEXT,
      wikipedia TEXT,
      website TEXT,
      twitter TEXT,
      description TEXT
    )
  ''');

  await db.execute('''
      CREATE TABLE history(
        id TEXT PRIMARY KEY,
        title TEXT,
        eventDateUtc TEXT,
        details TEXT
      )
    ''');
}

Future<int> insertLaunch(SpaceXLaunch launch) async {
  Database db = await database;
  return await db.insert(
    'launches',
    launch.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<SpaceXLaunch>> getLaunches() async {
  Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('launches');
  return List.generate(maps.length, (i) {
    return SpaceXLaunch.fromMap(maps[i]);
  });
}

Future<int> insertMission(Mission mission) async {
  Database db = await database;
  return await db.insert(
    'missions',
    {
      'missionId': mission.missionId,
      'missionName': mission.missionName,
      'manufacturers': mission.manufacturers.join(','), // Convert list to string
      'payloadIds': mission.payloadIds.join(','), // Convert list to string
      'wikipedia': mission.wikipedia,
      'website': mission.website,
      'twitter': mission.twitter,
      'description': mission.description,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Mission>> getMissions() async {
  Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('missions');
  return List.generate(maps.length, (i) {
    return Mission(
      missionName: maps[i]['missionName'],
      missionId: maps[i]['missionId'],
      manufacturers: maps[i]['manufacturers'].split(','), // Convert string to list
      payloadIds: maps[i]['payloadIds'].split(','), // Convert string to list
      wikipedia: maps[i]['wikipedia'],
      website: maps[i]['website'],
      twitter: maps[i]['twitter'],
      description: maps[i]['description'],
    );
  });
}

  Future<int> insertHistory(History history) async {
    Database db = await database;
    return await db.insert(
      'history',
      {
        'id': history.id,
        'title': history.title,
        'eventDateUtc': history.eventDateUtc,
        'details': history.details,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<History>> getHistory() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('history');
    return List.generate(maps.length, (i) {
      return History(
        id: maps[i]['id'],
        title: maps[i]['title'],
        eventDateUtc: maps[i]['eventDateUtc'],
        details: maps[i]['details'],
      );
    });
  }
}