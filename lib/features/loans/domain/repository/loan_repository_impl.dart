import 'package:calculations/features/employees/data/datasources/employee_local_data_source.dart';
import 'package:calculations/features/employees/data/datasources/employee_local_data_source_impl.dart';
import 'package:calculations/features/employees/data/model/employee_model.dart';
import 'package:calculations/features/loans/data/datasources/loan_local_data_source.dart';
import 'package:calculations/features/loans/data/datasources/loan_local_data_source_impl.dart';
import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:calculations/features/loans/domain/repository/loan_repository.dart';

class LoanRepositoryImpl implements LoanRepository{
  final EmployeeLocalDataSource employeeLocalDataSource = EmployeeLocalDataSourceImpl();
  final LoanLocalDataSource loanLocalDataSource = LoanLocalDataSourceImpl();
  @override
  Future<LoanModel> createNewLoan({
    required int employeeId, 
    required double amount, 
    required int type, 
    String? note
  }) async {
    final employee = await employeeLocalDataSource.getEmployee(employeeId);
    final newLoan = LoanModel(
      employee: employee,
      dateTime: DateTime.now(), // Fallback logic
      amount: amount,
      type: type,
      note: note,
    );
    int id = await loanLocalDataSource.createLoan(newLoan);
    return newLoan.copyWith(id: id);
  }

  @override
  Future<bool> deleteLoan(int id) async {
    return await loanLocalDataSource.deleteLoan(id);
  }

  @override
  Future<LoanModel> getLoan(int id) async {
    return await loanLocalDataSource.getLoan(id);
  }

  @override
  Future<List<LoanModel>> getLoans(int employeeId) async {
    final EmployeeModel employee = await employeeLocalDataSource.getEmployee(employeeId);
    return await loanLocalDataSource.getLoans(employee);
  }
  
  @override
  Future<LoanModel> updateLoan({required int id, required int employeeId, required double amount, required int type, required String note}) async {
    final loan = await loanLocalDataSource.getLoan(id);
    final employee = await employeeLocalDataSource.getEmployee(employeeId);
    final updatedLoan = LoanModel(
      id: id,
      employee: employee,
      dateTime: loan.dateTime,
      amount: amount,
      type: type,
      note: note,
    );
    await loanLocalDataSource.updateLoan(
      updatedLoan,
    );
    return updatedLoan;
  }
}