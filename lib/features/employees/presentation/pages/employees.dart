import 'package:calculations/features/employees/presentation/bloc/employee_bloc.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search),
                SizedBox(width: 10), // spacing
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                    },
                    decoration: InputDecoration(
                      hintText: "Search here",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<EmployeeBloc, EmployeeState>(
              listenWhen: (prev, curr) =>
                  curr.isDeleteSuccess && !prev.isDeleteSuccess,
              listener: (context, state) {
                if(state.isDeleteSuccess){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete Successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }else if(state.isEditSuccess){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit Successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.errorMessage != null) {
                  return Center(
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state.isLoading && state.employees.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.employees.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Employee Found",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.employees.length,
                  padding: EdgeInsets.only(top: 20, bottom: 70),
                  itemBuilder: (context, index) {
                    final employee = state.employees[index];
                    return EmployeeCard(employee: employee);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => EmployeeForm(),
            ),
          );
        },
        backgroundColor: Color(0xFF5B58FF),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
