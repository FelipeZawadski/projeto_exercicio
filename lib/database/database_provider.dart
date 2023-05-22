

import 'package:projeto_exercicio/model/ponto_remoto.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider{

  static const _dbName = 'cadastroPontoRemoto.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${PontoRemoto.NOME_TABLE} (
        ${PontoRemoto.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PontoRemoto.DATA} TEXT NOT NULL,
        ${PontoRemoto.LONGITUDE} REAL NOT NULL,
        ${PontoRemoto.LATITUDE} REAL NOT NULL,
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}