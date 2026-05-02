import 'package:calculations/features/loans/data/model/loan_model.dart';
import 'package:calculations/features/loans/domain/use_cases/create_loan_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/delete_loan_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/get_all_loan_of_employee_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/get_single_loan_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/update_loan_use_case.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_event.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final CreateLoanUseCase createLoanUseCase;
  final UpdateLoanUseCase updateLoanUseCase;
  final GetSingleLoanUseCase getSingleLoanUseCase;
  final GetAllLoanOfEmployeeUseCase getAllLoanOfEmployeeUseCase;
  final DeleteLoanUseCase deleteLoanUseCase;
  LoanBloc({
    required this.createLoanUseCase,
    required this.updateLoanUseCase,
    required this.getSingleLoanUseCase,
    required this.getAllLoanOfEmployeeUseCase,
    required this.deleteLoanUseCase,
  }) : super(LoanState()) {
    on<LoanCreateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final newLoan = await createLoanUseCase.execute(
        employeeId: event.employeeId,
        amount: event.amount,
        type: event.type,
        note: event.note,
      );
      final updatedLoans = [newLoan, ...(state.loans)];
      emit(
        state.copyWith(
          isLoading: false,
          loans: updatedLoans,
          totalLoan: state.totalLoan + event.amount,
        ),
      );
    });
    on<LoanUpdateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final updatedLoan = await updateLoanUseCase.execute(
        id: event.id,
        employeeId: event.employeeId,
        type: event.type,
        amount: event.amount,
        note: event.note,
      );

      double newTotal = 0;

      final updatedList = state.loans.map((loan) {
        final currentTotal = loan.id == event.id ? updatedLoan : loan;
        if(currentTotal.type == 1){
          newTotal = newTotal + currentTotal.amount;
        } 
        return currentTotal;
      }).toList();

      emit(
        state.copyWith(
          isLoading: false,
          loans: updatedList,
          totalLoan: newTotal,
        ),
      );

    });
    on<LoadLoansEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final loans = await getAllLoanOfEmployeeUseCase.execute(event.employeeId);
      final totalLoan = loans
          .where((loan) => loan.type == 1) // 1 = addition
          .fold<double>(
            0,
            (previousValue, element) => previousValue + element.amount,
          );
      emit(
        state.copyWith(isLoading: false, loans: loans, totalLoan: totalLoan),
      );
    });
    on<LoanDeleteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final LoanModel selectedLoan = await getSingleLoanUseCase.execute(event.id);
      var updatedTotalLoan = state.totalLoan;
      if(selectedLoan.type == 1){
        updatedTotalLoan = state.totalLoan - selectedLoan.amount;
      }
      await deleteLoanUseCase.execute(event.id);
      final updatedLoans = state.loans
          .where((loan) => loan.id != event.id)
          .toList();
      emit(state.copyWith(isLoading: false, loans: updatedLoans, totalLoan: updatedTotalLoan));
    });
  }
}
