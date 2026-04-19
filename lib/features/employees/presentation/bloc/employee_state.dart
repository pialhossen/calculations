import 'package:calculations/features/employees/domain/entities/employee.dart';

enum EmployeeActiveStatus {none, deleted, updated, created}

class EmployeeState {
  final List<Employee> employees;
  final Employee? selectedEmployee;
  final bool isLoading;
  final String? errorMessage;
  final String? q;
  final bool isDeleteSuccess;
  final bool isEditSuccess;
  final EmployeeActiveStatus lastActive;

  EmployeeState({
    this.employees = const [],
    this.selectedEmployee,
    this.isLoading = false,
    this.errorMessage,
    this.isDeleteSuccess = false,
    this.isEditSuccess = false,
    this.lastActive = EmployeeActiveStatus.none,
    this.q,
  });

  // This is the secret sauce
  EmployeeState copyWith({
    List<Employee>? employees,
    Employee? selectedEmployee,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleteSuccess,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleteSuccess: isDeleteSuccess ?? this.isDeleteSuccess,
    );
  }
}