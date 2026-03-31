import 'package:calculations/core/widgets/input.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_bloc.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeForm extends StatefulWidget {
  final int? id;
  static MaterialPageRoute route(EmployeeBloc bloc) => MaterialPageRoute(builder: (context) => BlocProvider.value(value: bloc, child: const EmployeeForm()),);

  const EmployeeForm({super.key, this.id});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    if (widget.id != null) {
      context.read<EmployeeBloc>().add(LoadSingleEmployeeData(widget.id!));
      nameController.text = ""; 
      phoneController.text = "";
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void createEmployee() {
      if (formKey.currentState!.validate()) {
        Navigator.pop(context);
        context.read<EmployeeBloc>().add(
          EmployeeCreateEvent(nameController.text, phoneController.text),
        );
      }
    }
    void updateEmployee() {
      if (formKey.currentState!.validate()) {
        Navigator.pop(context);
        context.read<EmployeeBloc>().add(
          EmployeeUpdateEvent(widget.id!,nameController.text, phoneController.text),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8), // adjust this
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Transform.translate(
          offset: Offset(-10, 0),
          child: Text(
            widget.id == null? "Add New Employee": "Edit Employee", // use the passed title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listenWhen: (prev, curr) => prev.selectedEmployee != curr.selectedEmployee,
        listener: (context, state) {
          if (state.selectedEmployee != null) {
            nameController.text = state.selectedEmployee!.name;
            phoneController.text = state.selectedEmployee!.number;
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: const  CircularProgressIndicator());
          }
          return Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Input(
                    label: 'NAME',
                    placeholder: 'Enter Employee Name',
                    controller: nameController,
                  ),
                  SizedBox(height: 20),
                  Input(
                    label: 'PHONE NUMBER',
                    placeholder: 'Enter Employee Phone',
                    controller: phoneController,
                  ),
                  GestureDetector(
                    onTap: widget.id == null? createEmployee: updateEmployee,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.id == null? "ADD": "UPDATE",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
