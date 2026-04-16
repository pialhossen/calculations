import 'package:calculations/features/slips/data/model/slip_item_model.dart';
import 'package:calculations/features/slips/data/model/slip_model.dart';

abstract interface class SlipRepository {
  Future<SlipModel> createNewSlip({required int employeeId, required double totalAmount, required List<SlipItemModel> slipItems, required String? note});
  Future<SlipModel> updateSlip(int id, {required int employeeId, required double totalAmount, required List<SlipItemModel> slipItems, required String? note});
  Future<bool> deleteSlip(int id);
  Future<SlipModel> getSlip(int id);
  Future<List<SlipModel>> getSlips();
}