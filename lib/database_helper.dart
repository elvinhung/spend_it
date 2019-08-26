import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tablePayments = 'payments';
final String columnId = '_id';
final String columnName = 'name';
final String columnCategory = 'category';
final String columnYear = 'year';
final String columnMonth = 'month';
final String columnDay = 'day';
final String columnPrice = 'price';

class Payment {
  int id;
  String name;
  String category;
  int year;
  int month;
  int day;
  double price;

  Payment();

  // convenience constructor to create a Word object
  Payment.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    category = map[columnCategory];
    year = map[columnYear];
    month = map[columnMonth];
    day = map[columnDay];
    price = map[columnPrice];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnName: name,
      columnPrice: price,
      columnYear: year,
      columnMonth: month,
      columnDay: day,
      columnCategory: category,
    };
    return map;
  }

}

class DatabaseHelper {
  static final _databaseName = "MyPaymentsDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tablePayments (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnPrice DOUBLE NOT NULL,
                $columnCategory TEXT NOT NULL,
                $columnYear INTEGER NOT NULL,
                $columnMonth INTEGER NOT NULL,
                $columnDay INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:
  Future<int> insert(Payment payment) async {
    Database db = await database;
    int id = await db.insert(tablePayments, payment.toMap());
    return id;
  }

  Future<int> delete(int id) async {
    Database db = await database;
    int numDeleted = await db.delete(tablePayments, where: '$columnId = ?', whereArgs: [id]);
    print('$numDeleted rows deleted');
    return numDeleted;
  }

  Future<int> update(Payment payment) async {
    Database db = await database;
    int numUpdated = await db.update(tablePayments, payment.toMap(), where: '$columnId = ?', whereArgs: [payment.id]);
    return numUpdated;
  }

  Future<Payment> queryPaymentById(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tablePayments,
        columns: [columnId, columnName, columnPrice, columnCategory, columnYear, columnMonth, columnDay],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Payment.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Payment>> queryPaymentsByMonth(int year, int month) async {
    Database db = await database;
    List<Map> maps = await db.query(tablePayments,
        columns: [columnId, columnName, columnPrice, columnCategory, columnYear, columnMonth, columnDay],
        where: '$columnYear = ? AND $columnMonth = ?',
        whereArgs: [year, month]);
    List<Payment> list = maps.isNotEmpty ? maps.map((c) => Payment.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> getMaxId() async {
    Database db = await database;
    var table = await db.rawQuery('SELECT MAX($columnId)+1 as $columnId FROM $tablePayments');
    return table.first[columnId];
  }

  deleteAll() async {
    Database db = await database;
    db.delete(tablePayments, where: '1');
  }

}