import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class GetAllEmployeeUseCase {
  final EmployeeRepository repository;
  GetAllEmployeeUseCase(this.repository);
  Future<List<Employee>> execute(String? q) async {
    return await repository.getEmployees(q);
  }
}