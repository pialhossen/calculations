abstract class EmployeeEvent {}

class EmployeeCreateEvent extends EmployeeEvent {
  final String name;
  final String number;
  EmployeeCreateEvent(this.name, this.number);
}
class EmployeeUpdateEvent extends EmployeeEvent {

}
class EmployeeRemoveEvent extends EmployeeEvent {

}
class LoadEmployeesEvent extends EmployeeEvent{
  
}