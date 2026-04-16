import 'package:calculations/features/slips/domain/use_cases/create_slip_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/delete_slip_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/get_all_slip_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/get_single_slip_model_use_case.dart';
import 'package:calculations/features/slips/domain/use_cases/update_slip_use_case.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_event.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlipBloc extends Bloc<SlipEvent, SlipState> {
  final CreateSlipUseCase createSlipUseCase;
  final UpdateSlipUseCase updateSlipUseCase;
  final GetAllSlipUseCase getAllSlipUseCase;
  final DeleteSlipUseCase deleteSlipUseCase;
  final GetSingleSlipModelUseCase getSingleSlipModelUseCase;
  SlipBloc({
    required this.createSlipUseCase,
    required this.updateSlipUseCase,
    required this.getAllSlipUseCase,
    required this.deleteSlipUseCase,
    required this.getSingleSlipModelUseCase,
  }): super(SlipState()){
    on<SlipCreateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final newSlip = await createSlipUseCase.execute(
          employeeId: event.employeeId,
          slipItems: event.slipItems,
          totalAmount: event.totalAmount,
          note: event.note,
        );
        emit(state.copyWith(isLoading: false, slips: [newSlip, ...state.slips]));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
    on<SlipUpdateEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final updatedSlip = await updateSlipUseCase.execute(
          id: event.id, 
          employeeId: event.employeeId, 
          slipItems: event.slipItems,
          totalAmount: event.totalAmount,
          note: event.note
        );
        final updateSlipList = state.slips.map((slip) => slip.id == event.id? updatedSlip: slip).toList();
        emit(state.copyWith(isLoading: false, slips: updateSlipList));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
    on<LoadSlipEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final slips = await getAllSlipUseCase.execute();
        emit(state.copyWith(isLoading: false, slips: slips));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
    on<SlipDeleteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await deleteSlipUseCase.execute(event.id);
        final slips = await getAllSlipUseCase.execute();
        emit(state.copyWith(isLoading: false, slips: slips));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
    on<LoadSingleSlipEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, selectedSlip: null));
      try {
        final slip = await getSingleSlipModelUseCase.execute(event.id);
        emit(state.copyWith(isLoading: false, selectedSlip: slip));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
  }
  
}