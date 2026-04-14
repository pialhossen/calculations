import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employee(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT,
        number TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE product(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT,
        perkg INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE slips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER,
        total_amount REAL,
        date_created TEXT,
        note TEXT,
        FOREIGN KEY (employee_id) REFERENCES employee (id)
      )
    ''');
    await db.execute(
      '''
      CREATE TABLE slip_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        slip_id INTEGER,
        product_name TEXT,
        kg REAL,
        per_kg REAL,
        row_total REAL,
        FOREIGN KEY (slip_id) REFERENCES slips (id) ON DELETE CASCADE
      )
      '''
    );
  }
}