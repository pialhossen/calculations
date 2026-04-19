import 'package:calculations/features/employees/domain/use_cases/create_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/delete_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_all_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_single_employee_model_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/update_employee_use_case.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState>{
  final CreateEmployeeUseCase createEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final GetAllEmployeeUseCase getAllUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;
  final GetSingleEmployeeModelUseCase getSingleEmployeeModelUseCase;
  EmployeeBloc({
    required this.createEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.getAllUseCase,
    required this.deleteEmployeeUseCase,
    required this.getSingleEmployeeModelUseCase,
  }) : super(EmployeeState()) {
    on<EmployeeCreateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        final newEmployee = await createEmployeeUseCase.execute(event.name, event.number);
        emit(state.copyWith(isLoading: false, employees: [newEmployee, ...state.employees]));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<EmployeeUpdateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        final updatedEmployee = await updateEmployeeUseCase.execute(event.id, event.name, event.number);
        final updateEmployeeList = state.employees.map((employee) => employee.id == event.id? updatedEmployee: employee).toList();
        emit(state.copyWith(isLoading: false, employees: updateEmployeeList));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<LoadEmployeesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        final employees = await getAllUseCase.execute(event.q);
        emit(state.copyWith(isLoading: false, employees: employees));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<EmployeeDeleteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // try {
        await deleteEmployeeUseCase.execute(event.id);
        final employees = await getAllUseCase.execute(event.q);
        emit(state.copyWith(isLoading: false, employees: employees));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
    on<LoadSingleEmployeeData>((event, emit) async {
      emit(state.copyWith(isLoading: true, selectedEmployee: null));
      // try {
        final employee = await getSingleEmployeeModelUseCase.execute(event.id);
        emit(state.copyWith(isLoading: false, selectedEmployee: employee));
      // } catch (e) {
      //   emit(state.copyWith(errorMessage: e.toString()));
      // }
    });
  }
}