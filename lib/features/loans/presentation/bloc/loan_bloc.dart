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

      final oldLoan = state.loans.firstWhere((loan) => loan.id == event.id);

      final updatedLoan = await updateLoanUseCase.execute(
        id: event.id,
        employeeId: event.employeeId,
        type: event.type,
      );

      print(oldLoan.type);
      print(event.type);

      final updatedList = state.loans.map((loan) {
        return loan.id == event.id ? updatedLoan : loan;
      }).toList();

      double newTotal = state.totalLoan;

      if (oldLoan.type == 0 && event.type == 1) {
        newTotal += oldLoan.amount;
      }

      else if (oldLoan.type == 1 && event.type == 0) {
        newTotal -= oldLoan.amount;
      }

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
      await deleteLoanUseCase.execute(event.id);
      final updatedLoans = state.loans
          .where((loan) => loan.id != event.id)
          .toList();
      emit(state.copyWith(isLoading: false, loans: updatedLoans));
    });
  }
}
