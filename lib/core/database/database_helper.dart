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
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Set up foreign keys globally for every connection
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    // 1. Employee Table
    await db.execute('''
      CREATE TABLE employee(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT,
        number TEXT,
        loan_amount REAL DEFAULT 0,
        image TEXT NULL
      )
    ''');

    // 2. Product Table
    await db.execute('''
      CREATE TABLE product(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT,
        perkg INTEGER,
        image TEXT NULL
      )
    ''');

    // 3. Slips Table
    await db.execute('''
      CREATE TABLE slips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER,
        total_amount REAL,
        date_created TEXT,
        note TEXT,
        FOREIGN KEY (employee_id) REFERENCES employee (id) ON DELETE CASCADE
      )
    ''');

    // 4. Slip Items Table
    await db.execute('''
      CREATE TABLE slip_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        slip_id INTEGER,
        product_id INTEGER,
        kg REAL,
        per_kg REAL,
        row_total REAL,
        FOREIGN KEY (slip_id) REFERENCES slips (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
      )
    ''');

    // 5. Loan Table (Triggers removed)
    await db.execute('''
      CREATE TABLE loan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER NOT NULL,
        amount REAL,
        type INTEGER, -- 1 = addition, 0 = subtraction
        date_created TEXT,
        note TEXT NULL,
        FOREIGN KEY (employee_id) REFERENCES employee (id) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add missing columns to existing tables
      await _safeAddColumn(db, 'employee', 'loan_amount', 'REAL DEFAULT 0');
      await _safeAddColumn(db, 'employee', 'image', 'TEXT NULL');
      await _safeAddColumn(db, 'product', 'image', 'TEXT NULL');

      // Create loan table if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS loan(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          employee_id INTEGER NOT NULL,
          amount REAL,
          type INTEGER,
          date_created TEXT,
          note TEXT NULL,
          FOREIGN KEY (employee_id) REFERENCES employee (id) ON DELETE CASCADE
        )
      ''');

      // Drop triggers if they exist (Clean up from previous version attempts)
      await db.execute('DROP TRIGGER IF EXISTS update_employee_loan_after_insert');
      await db.execute('DROP TRIGGER IF EXISTS update_employee_loan_after_update');
      await db.execute('DROP TRIGGER IF EXISTS update_employee_loan_after_delete');
    }
  }

  // Helper method to prevent crashes if column already exists
  Future<void> _safeAddColumn(Database db, String table, String column, String type) async {
    try {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type');
    } catch (e) {
      // Column already exists, ignore the error
    }
  }
}