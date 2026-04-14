import 'package:calculations/features/slips/data/model/slip_model.dart';

abstract interface class SlipsLocalDataSource {
  Future<int> createSlip(SlipModel slip);
  Future<int> updateSlip(SlipModel slip);
  Future<bool> deleteSlip(int id);
  Future<SlipModel> getSlip(int id);
  Future<List<SlipModel>> getSlips();
}