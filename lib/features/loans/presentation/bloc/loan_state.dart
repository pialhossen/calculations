import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/loans/domain/entities/loan.dart';

class LoanState {
  final Employee? employee;
  final List<Loan> loans;
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleteSuccess;
  final bool isEditSuccess;

  LoanState({
    this.loans = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isDeleteSuccess = false,
    this.isEditSuccess = false, 
    this.employee,
  });

  // This is the secret sauce
  LoanState copyWith({
    List<Loan>? loans,
    Employee? employee,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleteSuccess,
    bool? isEditSuccess,
  }) {
    return LoanState(
      loans: loans ?? this.loans,
      employee: employee ?? this.employee,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleteSuccess: isDeleteSuccess ?? this.isDeleteSuccess,
      isEditSuccess: isEditSuccess ?? this.isEditSuccess,
    );
  }
}