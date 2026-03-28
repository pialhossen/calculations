import 'package:calculations/features/employees/data/model/employee_model.dart';

abstract interface class EmployeeLocalDataSource {
  Future<int> createEmployee(EmployeeModel employee);
  Future<int> updateEmployee(EmployeeModel employee);
  Future<bool> deleteEmployee(int id);
  Future<EmployeeModel> getEmployee(int id);
  Future<List<EmployeeModel>> getEmployees();
}