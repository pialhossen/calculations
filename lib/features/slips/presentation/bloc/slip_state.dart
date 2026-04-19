import 'package:calculations/features/slips/data/model/slip_model.dart';

class SlipState {
  final List<SlipModel> slips;
  final SlipModel? selectedSlip;
  final DateTime selectedDate;
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleteSuccess;
  final bool isEditSuccess;

  SlipState({
    this.slips = const [],
    this.selectedSlip,
    DateTime? selectedDate,
    this.isLoading = false,
    this.errorMessage,
    this.isDeleteSuccess = false,
    this.isEditSuccess = false,
  }) : selectedDate = selectedDate ?? DateTime.now();
  SlipState copyWith({
    List<SlipModel>? slips,
    SlipModel? selectedSlip,
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleteSuccess,
  }) {
    return SlipState(
      slips: slips ?? this.slips,
      selectedSlip: selectedSlip ?? this.selectedSlip,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleteSuccess: isDeleteSuccess ?? this.isDeleteSuccess,
    );
  }
}