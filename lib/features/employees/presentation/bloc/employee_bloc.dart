import 'package:calculations/features/employees/domain/use_cases/create_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_all_employee_use_case.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState>{
  final CreateEmployeeUseCase createEmployeeUseCase;
  final GetAllEmployeeUseCase getAllUseCase;
  EmployeeBloc({
    required this.createEmployeeUseCase,
    required this.getAllUseCase,
  }) : super(EmployeeInitial()) {
    on<EmployeeCreateEvent>((event, emit) async {
      emit(EmployeeLoading());
      try {
        await createEmployeeUseCase.execute(event.name, event.number);
        final employees = await getAllUseCase.execute();
        emit(EmployeeSuccess(employees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });
    on<LoadEmployeesEvent>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final employees = await getAllUseCase.execute();
        emit(EmployeeSuccess(employees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });
  }
}