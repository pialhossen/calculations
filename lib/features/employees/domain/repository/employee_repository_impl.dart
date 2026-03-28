import 'package:calculations/features/employees/data/datasources/employee_local_data_source.dart';
import 'package:calculations/features/employees/data/datasources/employee_local_data_source_impl.dart';
import 'package:calculations/features/employees/data/model/employee_model.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource employeeLocalDataSource = EmployeeLocalDataSourceImpl();
  @override
  Future<EmployeeModel> createNewEmployee(String name, String number) async {
    final newEmployee = EmployeeModel(name: name, number: number);
    final id = await employeeLocalDataSource.createEmployee(newEmployee);
    return newEmployee.copyWith(id: id);
  }
  @override
  Future<List<EmployeeModel>> getEmployees() async {
    return await employeeLocalDataSource.getEmployees();
  }
  
  @override
  Future<bool> deleteEmployee(int id) {
    return employeeLocalDataSource.deleteEmployee(id);
  }
  
  @override
  Future<EmployeeModel> getEmployee(int id) async {
    return await employeeLocalDataSource.getEmployee(id);
  }
  
  @override
  Future<EmployeeModel> updateEmployee(int id, String name, String number) async {
    final updatedEmployee = EmployeeModel(id: id,name: name, number: number);
    employeeLocalDataSource.updateEmployee(updatedEmployee);
    return updatedEmployee;
  }
}