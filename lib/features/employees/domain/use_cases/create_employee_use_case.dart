import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository repository;
  CreateEmployeeUseCase(this.repository);
  Future<Employee> execute({ required String name, required String number, required double loanAmount, required String? image}) {
    return repository.createNewEmployee(name, number, loanAmount, image);
  }
}