import 'package:calculations/core/database/database_helper.dart';
import 'package:calculations/features/employees/data/model/employee_model.dart';
import 'package:sqflite/sqflite.dart';

abstract interface class EmployeeLocalDataSource {
  Future<int> createEmployee({required EmployeeModel employee});
  Future<List<Map<String, dynamic>>> getEmployees();
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource{

  @override
  Future<int> createEmployee({required EmployeeModel employee}) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('employee', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  @override
  Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('employee');
  }

}