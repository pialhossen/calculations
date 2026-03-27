import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class UpdateEmployeeUseCase {
  final EmployeeRepository repository;
  UpdateEmployeeUseCase(this.repository);
  Future<Employee> execute(int id, String name, String number) {
    return repository.updateEmployee(id ,name, number);
  }
}