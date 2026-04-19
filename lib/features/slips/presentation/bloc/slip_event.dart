import 'package:calculations/features/slips/data/model/slip_item_model.dart';

class SlipEvent {}

class SlipCreateEvent extends SlipEvent {
  final int employeeId;
  final double totalAmount;
  final List<SlipItemModel> slipItems;
  final String? note;
  SlipCreateEvent({
    required this.employeeId, 
    required this.totalAmount, 
    required this.slipItems, 
    this.note
  });
}
class SlipUpdateEvent extends SlipEvent {
  final int id;
  final int employeeId;
  final double totalAmount;
  final List<SlipItemModel> slipItems;
  final String? note;
  SlipUpdateEvent({
    required this.id, 
    required this.employeeId, 
    required this.totalAmount,
    required this.slipItems,
    this.note,
  });
}
class LoadSingleSlipEvent extends SlipEvent {
  final int id;
  LoadSingleSlipEvent(this.id);
}
class SlipDeleteEvent extends SlipEvent {
  final int id;
  final DateTime dateTime;
  SlipDeleteEvent({required this.id, required this.dateTime});
}
class LoadSlipEvent extends SlipEvent{
  final DateTime dateTime;
  LoadSlipEvent({required this.dateTime});
}