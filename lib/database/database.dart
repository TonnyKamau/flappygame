import 'package:flappygame/models/model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase extends ChangeNotifier {
  AppDatabase._init();
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('scores.db');
    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName (
      $columnId $idType,
      $columnScore $integerType,
      $columnDate $integerType
    )
  ''');
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<int> getHighestScore() async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      columns: [columnScore],
      orderBy: '$columnScore DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first[columnScore] as int;
    }
    return 0; // Default to 0 if no scores exist
  }

  Future<List<int>> getTopTwoScores() async {
    final db = await instance.database;

    final result = await db.query(
      'scores',
      columns: ['score'],
      orderBy: 'score DESC',
      limit: 2,
    );

    return result.map((row) => row['score'] as int).toList();
  }

  Future<void> insertScoreAndUpdateRanks(Score score) async {
    final db = await instance.database;

    // Fetch the top two scores
    final topScores = await getTopTwoScores();
    int highestScore = topScores.isNotEmpty ? topScores[0] : 0;
    int secondHighestScore = topScores.length > 1 ? topScores[1] : 0;

    if (score.score > highestScore) {
      await db.insert('scores', score.toJson());
      notifyListeners();
    } else if (score.score > secondHighestScore) {
      await db.insert('scores', score.toJson());
      notifyListeners();
    }
  }
}
