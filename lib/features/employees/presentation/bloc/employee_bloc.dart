import 'dart:io';

import 'package:calculations/features/employees/domain/use_cases/create_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/delete_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_all_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_single_employee_model_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/update_employee_use_case.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_bloc.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final CreateEmployeeUseCase createEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final GetAllEmployeeUseCase getAllUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;
  final GetSingleEmployeeModelUseCase getSingleEmployeeModelUseCase;
  final LoanBloc loanBloc;
  EmployeeBloc({
    required this.createEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.getAllUseCase,
    required this.deleteEmployeeUseCase,
    required this.getSingleEmployeeModelUseCase,
    required this.loanBloc,
  }) : super(EmployeeState()) {
    on<EmployeeCreateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      String? imagePath;

      if (event.image != null) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String path = appDocDir.path;

        final String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${p.basename(event.image!.path)}";
        final String localPath = '$path/$fileName';

        final File localImage = await File(event.image!.path).copy(localPath);

        imagePath = localImage.path;
      }

      final newEmployee = await createEmployeeUseCase.execute(
        name: event.name,
        number: event.number,
        loanAmount: event.loanAmount,
        image: imagePath,
      );

      if (event.loanAmount > 0) {
        loanBloc.add(
          LoanCreateEvent(
            amount: event.loanAmount,
            employeeId: newEmployee.id!,
            type: 1,
            note: "",
          ),
        );
      }

      emit(
        state.copyWith(
          isLoading: false,
          employees: [newEmployee, ...state.employees],
        ),
      );
    });
    on<EmployeeUpdateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final oldEmployee = state.employees.firstWhere((e) => e.id == event.id);
      String? imagePath = oldEmployee.image;

      if (event.image != null) {
        if (oldEmployee.image != null) {
          final oldFile = File(oldEmployee.image!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        }

        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String path = appDocDir.path;
        final String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${p.basename(event.image!.path)}";
        final String localPath = '$path/$fileName';

        final File localImage = await File(event.image!.path).copy(localPath);
        imagePath = localImage.path;
      }

      final updatedEmployee = await updateEmployeeUseCase.execute(
        id: event.id,
        name: event.name,
        number: event.number,
        loanAmount: event.loanAmount,
        image: imagePath,
      );

      final updateEmployeeList = state.employees.map((employee) {
        return employee.id == event.id ? updatedEmployee : employee;
      }).toList();

      emit(state.copyWith(isLoading: false, employees: updateEmployeeList));
    });
    on<LoadEmployeesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final employees = await getAllUseCase.execute(event.q);
      emit(state.copyWith(isLoading: false, employees: employees));
    });
    on<EmployeeDeleteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final employeeToDelete = state.employees.firstWhere(
          (e) => e.id == event.id,
        );

        if (employeeToDelete.image != null) {
          final file = File(employeeToDelete.image!);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } catch (e) {
        debugPrint("Error deleting image file: $e");
      }

      await deleteEmployeeUseCase.execute(event.id);

      final employees = await getAllUseCase.execute(event.q);
      emit(state.copyWith(isLoading: false, employees: employees));
    });
    on<LoadSingleEmployeeData>((event, emit) async {
      emit(state.copyWith(isLoading: true, selectedEmployee: null));
      final employee = await getSingleEmployeeModelUseCase.execute(event.id);
      emit(state.copyWith(isLoading: false, selectedEmployee: employee));
    });
  }
}
