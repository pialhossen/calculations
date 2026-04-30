import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository repository;
  CreateEmployeeUseCase(this.repository);
  Future<Employee> execute(String name, String number, double loanAmount) {
    return repository.createNewEmployee(name, number, loanAmount);
  }
}