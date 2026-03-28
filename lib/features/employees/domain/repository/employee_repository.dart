import 'package:calculations/features/employees/data/model/employee_model.dart';

abstract interface class EmployeeRepository {
  Future<EmployeeModel> createNewEmployee(String name, String number);
  Future<EmployeeModel> updateEmployee(int id,String name, String number);
  Future<bool> deleteEmployee(int id);
  Future<EmployeeModel> getEmployee(int id);
  Future<List<EmployeeModel>> getEmployees();
}