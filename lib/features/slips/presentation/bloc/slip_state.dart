import 'package:calculations/features/slips/data/model/slip_model.dart';
import 'package:calculations/features/slips/domain/entities/slip_entity.dart';

class SlipState {
  final List<SlipModel> slips;
  final SlipModel? selectedSlip;
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleteSuccess;
  final bool isEditSuccess;

  SlipState({
    this.slips = const [],
    this.selectedSlip,
    this.isLoading = false,
    this.errorMessage,
    this.isDeleteSuccess = false,
    this.isEditSuccess = false,
  });
  SlipState copyWith({
    List<SlipModel>? slips,
    SlipModel? selectedSlip,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleteSuccess,
  }) {
    return SlipState(
      slips: slips ?? this.slips,
      selectedSlip: selectedSlip ?? this.selectedSlip,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleteSuccess: isDeleteSuccess ?? this.isDeleteSuccess,
    );
  }
}