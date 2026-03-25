import 'package:calculations/core/widgets/input.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_bloc.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesForm extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(builder: (context) => const EmployeesForm()); 

  const EmployeesForm({super.key});

  @override
  State<EmployeesForm> createState() => _EmployeesFormState();
}

class _EmployeesFormState extends State<EmployeesForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void createEmployee(){
    if(formKey.currentState!.validate()){
      context.read<EmployeeBloc>().add(
        EmployeeCreateEvent(nameController.text, phoneController.text)
      );
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
            "Add New Employee",           // use the passed title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if(state is EmployeeSuccess){
            Navigator.pop(context);
          } else if(state is EmployeeError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Input(
                  label: 'NAME', 
                  placeholder: 'Enter Employee Name', 
                  controller: nameController
                ),
                SizedBox(height: 20),
                Input(
                  label: 'PHONE NUMBER', 
                  placeholder: 'Enter Employee Phone', 
                  controller: phoneController
                ),
                GestureDetector(
                  onTap: createEmployee,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text(
                      "ADD",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14
                      ),
                    ),
                  ),
                  
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}