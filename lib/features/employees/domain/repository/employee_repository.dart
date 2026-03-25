import 'package:calculations/features/employees/data/datasources/employee_local_data_source.dart';
import 'package:calculations/features/employees/data/model/employee_model.dart';

abstract interface class EmployeeRepository {
  Future<void> createNewEmployee(String name, String number);
  Future<List<EmployeeModel>> getEmployees();
}
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource employeeLocalDataSource = EmployeeLocalDataSourceImpl();
  @override
  Future<void> createNewEmployee(String name, String number) async {
    final newEmployee = EmployeeModel(name: name, number: number);
    employeeLocalDataSource.createEmployee(employee: newEmployee);
  }
  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final maps = await employeeLocalDataSource.getEmployees();
    return maps.map((map) => EmployeeModel.fromMap(map)).toList();
  }
}