import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:flutter/material.dart';

class EmployeeSelect extends StatefulWidget {
  final List<Employee> employees;
  final void Function(Employee) onChange;
  final String? initialValue; // Pass the starting ID here

  const EmployeeSelect({
    super.key,
    required this.employees,
    required this.onChange,
    this.initialValue,
  });

  @override
  State<EmployeeSelect> createState() => _EmployeeSelectState();
}

class _EmployeeSelectState extends State<EmployeeSelect> {
  String? _internalValue;

  @override
  void initState() {
    super.initState();
    // Set the initial selection once when the widget is born
    _internalValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.employees.isEmpty) return const Text("...");

    // 1. Safety check: make sure the value actually exists in the list
    bool exists = widget.employees.any((p) => p.id.toString() == _internalValue);
    if (!exists) {
      _internalValue = widget.employees.first.id.toString();
    }

    return Container(
      width: 70,
      height: 30,
      child: DropdownButton<String>(
        value: _internalValue, // 2. Use the INTERNAL state variable
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.employees.map((Employee employee) {
          return DropdownMenuItem<String>(
            value: employee.id.toString(),
            child: Text(employee.name),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue == null) return;
          setState(() {
            _internalValue = newValue;
          });
          final selectedEmployee = widget.employees.firstWhere(
            (p) => p.id.toString() == newValue,
          );
          widget.onChange(selectedEmployee); 
        },
      ),
    );
  }
}