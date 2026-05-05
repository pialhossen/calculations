import 'package:calculations/features/employees/presentation/bloc/employee_bloc.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart'; // Make sure to import events
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
import 'package:calculations/features/employees/presentation/widget/employee_card.dart';
import 'package:calculations/features/employees/presentation/pages/employee_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Employees extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Employees());

  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      // 1. BlocConsumer now wraps the entire body
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listenWhen: (prev, curr) =>
            (curr.isDeleteSuccess && !prev.isDeleteSuccess) ||
            (curr.isEditSuccess && !prev.isEditSuccess),
        listener: (context, state) {
          if (state.isDeleteSuccess || state.isEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.isDeleteSuccess
                    ? 'Delete Successful!'
                    : 'Edit Successful!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if(state.q != null && state.q != ""){
            searchController.text = state.q ?? "";
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          context.read<EmployeeBloc>().add(LoadEmployeesEvent(q: value));
                        },
                        decoration: const InputDecoration(
                          hintText: "Search People",
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // List View Logic
              Expanded(
                child: _buildListContent(state),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const EmployeeForm(),
            ),
          );
        },
        backgroundColor: const Color(0xFF5B58FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Helper method to keep the builder clean
  Widget _buildListContent(EmployeeState state) {
    if (state.errorMessage != null) {
      return Center(
        child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (state.isLoading && state.employees.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.employees.isEmpty) {
      return const Center(
        child: Text(
          "No Peoples Found",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.employees.length,
      padding: const EdgeInsets.only(top: 5, bottom: 40, left: 8, right: 8),
      itemBuilder: (context, index) {
        final employee = state.employees[index];
        return EmployeeCard(employee: employee);
      },
    );
  }
}