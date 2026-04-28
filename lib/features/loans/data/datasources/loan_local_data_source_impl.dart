import 'package:calculations/core/database/database_helper.dart';
import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/loans/data/datasources/loan_local_data_source.dart';
import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LoanLocalDataSourceImpl implements LoanLocalDataSource {
  @override
  Future<int> createLoan(LoanModel loan) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(
      'loan',
      loan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<bool> deleteLoan(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.delete('loan', where: 'id = ?', whereArgs: [id]);
    return result > 0;
  }

  @override
  Future<LoanModel> getLoan(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'loan',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return LoanModel.fromMap(maps.first);
    } else {
      throw Exception("Loan with ID $id not found!");
    }
  }

  @override
  Future<List<LoanModel>> getLoans(Employee employee) async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps;

    maps = await db.query(
      'loan',
      where: 'employee_id = ?',
      whereArgs: [employee.id],
    );

    return maps.map((map) => LoanModel.fromMap(map)).toList();
  }

  @override
  Future<int> updateLoan(LoanModel loan) async {
    if (loan.id == null) {
      throw Exception("Cannot update an employee without an ID.");
    }
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'loan',
      loan.toMap(),
      where: 'id = ?',
      whereArgs: [loan.id],
    );
  }
  
}