import 'package:calculations/features/employees/domain/repository/employee_repository.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository repository;
  CreateEmployeeUseCase(this.repository);
  Future<void> execute(String name, String number) {
    return repository.createNewEmployee(name, number);
  }
}