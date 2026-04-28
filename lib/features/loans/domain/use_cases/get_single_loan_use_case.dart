import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:calculations/features/loans/domain/repository/loan_repository.dart';

class GetSingleLoanUseCase {
  final LoanRepository repository;
  GetSingleLoanUseCase(this.repository);
  Future<LoanModel> execute(int id) async {
    return await repository.getLoan(id);
  }
}