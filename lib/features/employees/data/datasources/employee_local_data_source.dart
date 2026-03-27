import 'package:calculations/core/database/database_helper.dart';
import 'package:calculations/features/employees/data/model/employee_model.dart';
import 'package:sqflite/sqflite.dart';

abstract interface class EmployeeLocalDataSource {
  Future<int> createEmployee({required EmployeeModel employee});
  Future<int> updateEmployee({required EmployeeModel employee});
  Future<bool> deleteEmployee({required int id});
  Future<Map<String, dynamic>> getEmployee({required int id});
  Future<List<Map<String, dynamic>>> getEmployees();
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource{

  @override
  Future<int> createEmployee({required EmployeeModel employee}) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('employee', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  @override
  Future<int> updateEmployee({required EmployeeModel employee}) async {
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
  Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(
      'employee',
      orderBy: 'id DESC',
    );
  }
  
  @override
  Future<bool> deleteEmployee({required int id}) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.delete(
      'employee', 
      where: 'id = ?', 
      whereArgs: [id],
    );
    return result > 0;
  }
  
  @override
  Future<Map<String, dynamic>> getEmployee({required int id}) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'employee',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );
    if(maps.isNotEmpty){
      return maps.first;
    } else {
      throw Exception("Employee with ID $id not found!");
    }
  }

}