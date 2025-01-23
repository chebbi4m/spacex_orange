import 'package:spacex_orange/models/history.dart';
import 'package:spacex_orange/models/launch.dart';
import 'package:spacex_orange/models/mission.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  // Generic insert method
  Future<int> _insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Generic query method
  Future<List<Map<String, dynamic>>> _query(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  // Insert and get methods for SpaceXLaunch
  Future<int> insertLaunch(SpaceXLaunch launch) async {
    return await _insert('launches', launch.toMap());
  }

  Future<List<SpaceXLaunch>> getLaunches() async {
    final List<Map<String, dynamic>> maps = await _query('launches');
    return maps.map((map) => SpaceXLaunch.fromMap(map)).toList();
  }

  // Insert and get methods for Mission
  Future<int> insertMission(Mission mission) async {
    return await _insert('missions', mission.toMap());
  }

  Future<List<Mission>> getMissions() async {
    final List<Map<String, dynamic>> maps = await _query('missions');
    return maps.map((map) => Mission.fromMap(map)).toList();
  }

  // Insert and get methods for History
  Future<int> insertHistory(History history) async {
    return await _insert('history', history.toMap());
  }

  Future<List<History>> getHistory() async {
    final List<Map<String, dynamic>> maps = await _query('history');
    return maps.map((map) => History.fromMap(map)).toList();
  }
}