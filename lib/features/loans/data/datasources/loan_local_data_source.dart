import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/loans/data/model/loan_model.dart';

abstract interface class LoanLocalDataSource {
  Future<int> createLoan(LoanModel loan);
  Future<int> updateLoan(LoanModel loan);
  Future<bool> deleteLoan(int id);
  Future<LoanModel> getLoan(int id);
  Future<List<LoanModel>> getLoans(Employee employee);
}