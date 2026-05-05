import 'package:calculations/core/database/database_helper.dart';
import 'package:calculations/features/employees/data/datasources/employee_local_data_source.dart';
import 'package:calculations/features/employees/data/model/employee_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  @override
  Future<int> createEmployee(EmployeeModel employee) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(
      'employee',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

   @override
  Future<bool> deleteEmployee(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.delete(
      'employee',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<int> updateEmployee(EmployeeModel employee) async {
    if (employee.id == null) {
      throw Exception("Cannot update an employee without an ID.");
    }
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'employee',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  @override
  Future<List<EmployeeModel>> getEmployees(String? q) async {
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> maps;

    if (q != null && q.trim().isNotEmpty) {
      maps = await db.query(
        'employee',
        where: 'name LIKE ? OR number LIKE ?',
        whereArgs: ['%$q%', '%$q%'],
        orderBy: 'id DESC',
      );
    } else {
      maps = await db.query('employee', orderBy: 'id DESC');
    }

    return maps.map((map) => EmployeeModel.fromMap(map)).toList();
  }

  @override
  Future<EmployeeModel> getEmployee(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'employee',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return EmployeeModel.fromMap(maps.first);
    } else {
      throw Exception("Employee with ID $id not found!");
    }
  }
}
