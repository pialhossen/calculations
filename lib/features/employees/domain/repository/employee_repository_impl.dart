import 'package:calculations/features/employees/data/datasources/employee_local_data_source.dart';
import 'package:calculations/features/employees/data/model/employee_model.dart';
import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource employeeLocalDataSource = EmployeeLocalDataSourceImpl();
  @override
  Future<EmployeeModel> createNewEmployee(String name, String number) async {
    final newEmployee = EmployeeModel(name: name, number: number);
    employeeLocalDataSource.createEmployee(employee: newEmployee);
    return newEmployee;
  }
  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final maps = await employeeLocalDataSource.getEmployees();
    return maps.map((map) => EmployeeModel.fromMap(map)).toList();
  }
  
  @override
  Future<bool> deleteEmployee(int id) {
    return employeeLocalDataSource.deleteEmployee(id: id);
  }
  
  @override
  Future<EmployeeModel> getEmployee(int id) async {
    final map = await employeeLocalDataSource.getEmployee(id: id);
    return EmployeeModel.fromMap(map);
  }
  
  @override
  Future<EmployeeModel> updateEmployee(int id, String name, String number) async {
    final updatedEmployee = EmployeeModel(id: id,name: name, number: number);
    employeeLocalDataSource.updateEmployee(employee: updatedEmployee);
    return updatedEmployee;
  }
}