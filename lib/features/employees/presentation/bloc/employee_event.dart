import 'dart:io';

abstract class EmployeeEvent {}

class EmployeeCreateEvent extends EmployeeEvent {
  final String name;
  final String number;
  final double loanAmount;
  final File? image;
  EmployeeCreateEvent({
    required this.name,
    required this.number,
    required this.loanAmount,
    this.image,
  });
}

class EmployeeUpdateEvent extends EmployeeEvent {
  final int id;
  final String name;
  final String number;
  final double loanAmount;
  final File? image;
  EmployeeUpdateEvent({
    required this.id,
    required this.name,
    required this.number,
    required this.loanAmount,
    required this.image
  });
}

class LoadSingleEmployeeData extends EmployeeEvent {
  final int id;
  LoadSingleEmployeeData(this.id);
}

class EmployeeDeleteEvent extends EmployeeEvent {
  final int id;
  final String? q;
  EmployeeDeleteEvent({required this.id, this.q});
}

class LoadEmployeesEvent extends EmployeeEvent {
  final String? q;
  LoadEmployeesEvent({this.q});
}
