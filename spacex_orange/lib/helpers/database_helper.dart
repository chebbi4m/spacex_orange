import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:spacex_orange/models/launch.dart';

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
  }

  Future<int> insertLaunch(SpaceXLaunch launch) async {
  Database db = await database;
  return await db.insert(
    'launches',
    launch.toJson(),
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


}