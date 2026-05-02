import 'package:calculations/features/loans/data/model/loan_model.dart';

abstract interface class LoanRepository {
  Future<LoanModel> createNewLoan({required int employeeId, required double amount, required int type, String? note});
  Future<LoanModel> updateLoan({required int id, required int employeeId, required double amount, required int type, required String note});
  Future<bool> deleteLoan(int id);
  Future<LoanModel> getLoan(int id);
  Future<List<LoanModel>> getLoans(int employeeId);
}