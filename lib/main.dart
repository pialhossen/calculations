import 'dart:io';

import 'package:calculations/features/employees/domain/repository/employee_repository_impl.dart';
import 'package:calculations/features/employees/domain/use_cases/create_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/delete_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_all_employee_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/get_single_employee_model_use_case.dart';
import 'package:calculations/features/employees/domain/use_cases/update_employee_use_case.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_bloc.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/loans/domain/repository/loan_repository_impl.dart';
import 'package:calculations/features/loans/domain/use_cases/create_loan_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/delete_loan_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/get_all_loan_of_employee_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/get_single_loan_use_case.dart';
import 'package:calculations/features/loans/domain/use_cases/update_loan_use_case.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_bloc.dart';
import 'package:calculations/features/loans/presentation/bloc/loan_event.dart';
import 'package:calculations/features/products/domain/repository/product_repository_impl.dart';
import 'package:calculations/features/products/domain/use_cases/create_product_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/get_all_products_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/get_single_product_model_use_case.dart';
import 'package:calculations/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:calculations/features/products/presentation/bloc/product_bloc.dart';
import 'package:calculations/features/products/presentation/bloc/product_event.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository_impl.dart';
import 'package:calculations/features/slips/domain/use_cases/create_slip_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/delete_slip_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/get_all_slip_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/get_single_slip_model_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/update_slip_use_case.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_bloc.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_event.dart';
import 'package:calculations/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI for desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // 1. Initialize your data layer
  final employeeRepository = EmployeeRepositoryImpl();
  final createEmployeeUseCase = CreateEmployeeUseCase(employeeRepository);
  final getAllUseCase = GetAllEmployeeUseCase(employeeRepository);
  final deleteEmployeeUseCase = DeleteEmployeeUseCase(employeeRepository);
  final getSingleEmployeeModelUseCase = GetSingleEmployeeModelUseCase(employeeRepository);
  final updateEmployeeUseCase = UpdateEmployeeUseCase(employeeRepository);

  final productRepository = ProductRepositoryImpl();
  final createProductUseCase = CreateProductUseCase(productRepository);
  final getAllProductsUseCase = GetAllProductsUseCase(productRepository);
  final deleteProductUseCase = DeleteProductUseCase(productRepository);
  final getSingleProductModelUseCase = GetSingleProductModelUseCase(productRepository);
  final updateProductUseCase = UpdateProductUseCase(productRepository);

  final slipRepository = SlipRepositoryImpl();
  final createSlipUseCase = CreateSlipUseCase(slipRepository);
  final getAllSlipUseCase = GetAllSlipUseCase(slipRepository);
  final deleteSlipUseCase = DeleteSlipUseCase(slipRepository);
  final getSingleSlipModelUseCase = GetSingleSlipModelUseCase(slipRepository);
  final updateSlipUseCase = UpdateSlipUseCase(slipRepository);

  final loanRepository = LoanRepositoryImpl();
  final createLoanUseCase = CreateLoanUseCase(loanRepository);
  final updateLoanUseCase = UpdateLoanUseCase(loanRepository);
  final getSingleLoanUseCase = GetSingleLoanUseCase(loanRepository);
  final getAllLoanOfEmployeeUseCase = GetAllLoanOfEmployeeUseCase(loanRepository);
  final deleteLoanUseCase = DeleteLoanUseCase(loanRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeeBloc(
            createEmployeeUseCase: createEmployeeUseCase,
            updateEmployeeUseCase: updateEmployeeUseCase,
            getAllUseCase: getAllUseCase,
            deleteEmployeeUseCase: deleteEmployeeUseCase,
            getSingleEmployeeModelUseCase: getSingleEmployeeModelUseCase
          )..add(LoadEmployeesEvent(q: null)),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            createProductUseCase: createProductUseCase, 
            updateProductUseCase: updateProductUseCase, 
            getAllProductUseCase: getAllProductsUseCase, 
            deleteProductUseCase: deleteProductUseCase, 
            getSingleProductModelUseCase: getSingleProductModelUseCase
          )..add(LoadProductsEvent())
        ),
        BlocProvider(
          create: (context) => SlipBloc(
            createSlipUseCase: createSlipUseCase, 
            updateSlipUseCase: updateSlipUseCase, 
            getAllSlipUseCase: getAllSlipUseCase, 
            deleteSlipUseCase: deleteSlipUseCase, 
            getSingleSlipModelUseCase: getSingleSlipModelUseCase
          )..add(LoadSlipEvent(dateTime: DateTime.now()))
        ),
        BlocProvider(
          create: (context) => LoanBloc(
            createLoanUseCase: createLoanUseCase, 
            updateLoanUseCase: updateLoanUseCase, 
            getSingleLoanUseCase: getSingleLoanUseCase, 
            getAllLoanOfEmployeeUseCase: getAllLoanOfEmployeeUseCase, 
            deleteLoanUseCase: deleteLoanUseCase
          )
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Layout(),
    );
  }
}