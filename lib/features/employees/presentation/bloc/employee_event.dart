abstract class EmployeeEvent {}

class EmployeeCreateEvent extends EmployeeEvent {
  final String name;
  final String number;
  final double loanAmount;
  EmployeeCreateEvent(this.name, this.number, this.loanAmount);
}
class EmployeeUpdateEvent extends EmployeeEvent {
  final int id;
  final String name;
  final String number;
  final double loanAmount;
  EmployeeUpdateEvent(this.id, this.name, this.number, this.loanAmount);
}
class LoadSingleEmployeeData extends EmployeeEvent{
  final int id;
  LoadSingleEmployeeData(this.id);
}
class EmployeeDeleteEvent extends EmployeeEvent {
  final int id;
  final String? q;
  EmployeeDeleteEvent({
    required this.id, this.q
  });
}
class LoadEmployeesEvent extends EmployeeEvent{
  final String? q;
  LoadEmployeesEvent({this.q});
}