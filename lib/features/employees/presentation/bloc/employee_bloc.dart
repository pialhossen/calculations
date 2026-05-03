import 'dart:io';

import 'package:calculations/features/employees/domain/use_cases/create_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/delete_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_all_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_single_employee_model_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/update_employee_use_case.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
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
  EmployeeBloc({
    required this.createEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.getAllUseCase,
    required this.deleteEmployeeUseCase,
    required this.getSingleEmployeeModelUseCase,
  }) : super(EmployeeState()) {
    on<EmployeeCreateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      String? imagePath;

      if (event.image != null) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String path = appDocDir.path;

        // 3. Create a unique name for the image
        final String fileName = p.basename(event.image!.path);
        final String localPath = '$path/$fileName';

        // 4. Copy the file to the local directory
        final File localImage = await File(event.image!.path).copy(localPath);

        imagePath = localImage.path;
      }

      final newEmployee = await createEmployeeUseCase.execute(
        name: event.name,
        number: event.number,
        loanAmount: event.loanAmount,
        image: imagePath,
      );

      emit(
        state.copyWith(
          isLoading: false,
          employees: [newEmployee, ...state.employees],
        ),
      );
    });
    on<EmployeeUpdateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      // 1. Get the current employee from state to check for an existing image
      final oldEmployee = state.employees.firstWhere((e) => e.id == event.id);
      String? imagePath = oldEmployee.image; // Default to existing path

      // 2. Check if a NEW image was provided in the event
      if (event.image != null) {
        // A. Delete the old physical file if it exists to save space
        if (oldEmployee.image != null) {
          final oldFile = File(oldEmployee.image!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        }

        // B. Save the new image to the local app directory (just like Create)
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String path = appDocDir.path;
        final String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${p.basename(event.image!.path)}";
        final String localPath = '$path/$fileName';

        final File localImage = await File(event.image!.path).copy(localPath);
        imagePath = localImage.path;
      }

      // 3. Execute the update UseCase with the new (or old) imagePath
      final updatedEmployee = await updateEmployeeUseCase.execute(
        id: event.id,
        name: event.name,
        number: event.number,
        loanAmount: event.loanAmount,
        image: imagePath, // Pass the managed path here
      );

      // 4. Update the list in the state
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
