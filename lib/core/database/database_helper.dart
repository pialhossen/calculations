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
      version: 2, // 🔥 bumped version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');

    await db.execute('''
      CREATE TABLE employee(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT,
        number TEXT,
        loan_amount REAL DEFAULT 0,
        image TEXT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE product(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT,
        perkg INTEGER,
        image TEXT NULL
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

    // ✅ New loan table
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
    await db.execute('''
      CREATE TRIGGER update_employee_loan_after_insert
      AFTER INSERT ON loan
      BEGIN
        UPDATE employee
        SET loan_amount = loan_amount + 
          CASE 
            WHEN NEW.type = 1 THEN NEW.amount      -- addition
            WHEN NEW.type = 0 THEN -NEW.amount     -- subtraction
            ELSE 0
          END
        WHERE id = NEW.employee_id;
      END;
    ''');
    await db.execute('''
        CREATE TRIGGER update_employee_loan_after_update
        AFTER UPDATE ON loan
        BEGIN
          UPDATE employee
          SET loan_amount = loan_amount 
            - CASE 
                WHEN OLD.type = 1 THEN OLD.amount
                WHEN OLD.type = 0 THEN -OLD.amount
                ELSE 0
              END
            + CASE 
                WHEN NEW.type = 1 THEN NEW.amount
                WHEN NEW.type = 0 THEN -NEW.amount
                ELSE 0
              END
          WHERE id = NEW.employee_id;
        END;
      ''');
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_employee_loan_after_update
        AFTER UPDATE ON loan
        BEGIN
          UPDATE employee
          SET loan_amount = loan_amount 
            - CASE 
                WHEN OLD.type = 1 THEN OLD.amount
                WHEN OLD.type = 0 THEN -OLD.amount
                ELSE 0
              END
            + CASE 
                WHEN NEW.type = 1 THEN NEW.amount
                WHEN NEW.type = 0 THEN -NEW.amount
                ELSE 0
              END
          WHERE id = NEW.employee_id;
        END;
      ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('PRAGMA foreign_keys = ON');

    if (oldVersion < 2) {
      // 🔹 Add new columns to employee
      await db.execute('ALTER TABLE employee ADD COLUMN loan_amount REAL DEFAULT 0');
      await db.execute('ALTER TABLE employee ADD COLUMN image TEXT NULL');
      await db.execute('ALTER TABLE product ADD COLUMN image TEXT NULL');

      // 🔹 Create loan table
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
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_employee_loan_after_insert
        AFTER INSERT ON loan
        BEGIN
          UPDATE employee
          SET loan_amount = loan_amount + 
            CASE 
              WHEN NEW.type = 1 THEN NEW.amount
              WHEN NEW.type = 0 THEN -NEW.amount
              ELSE 0
            END
          WHERE id = NEW.employee_id;
        END;
      ''');
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_employee_loan_after_update
        AFTER UPDATE ON loan
        BEGIN
          UPDATE employee
          SET loan_amount = loan_amount 
            - CASE 
                WHEN OLD.type = 1 THEN OLD.amount
                WHEN OLD.type = 0 THEN -OLD.amount
                ELSE 0
              END
            + CASE 
                WHEN NEW.type = 1 THEN NEW.amount
                WHEN NEW.type = 0 THEN -NEW.amount
                ELSE 0
              END
          WHERE id = NEW.employee_id;
        END;
      ''');
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_employee_loan_after_update
        AFTER UPDATE ON loan
        BEGIN
          UPDATE employee
          SET loan_amount = loan_amount 
            - CASE 
                WHEN OLD.type = 1 THEN OLD.amount
                WHEN OLD.type = 0 THEN -OLD.amount
                ELSE 0
              END
            + CASE 
                WHEN NEW.type = 1 THEN NEW.amount
                WHEN NEW.type = 0 THEN -NEW.amount
                ELSE 0
              END
          WHERE id = NEW.employee_id;
        END;
      ''');
    }
  }
}
