abstract class LoanEvent {}

class LoanCreateEvent extends LoanEvent {
  final int employeeId;
  final double amount;
  final int type;
  final String? note;

  LoanCreateEvent({
    required this.employeeId,
    required this.amount,
    required this.type,
    this.note,
  });
}

class LoanUpdateEvent extends LoanEvent {
  final int id;
  final int type;
  final int employeeId;
  final double amount;
  final String note;
  LoanUpdateEvent({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.amount,
    required this.note,
  });
}

class LoanDeleteEvent extends LoanEvent {
  final int id;
  LoanDeleteEvent(this.id);
}

class LoadLoansEvent extends LoanEvent {
  final int employeeId;
  LoadLoansEvent(this.employeeId);
}
