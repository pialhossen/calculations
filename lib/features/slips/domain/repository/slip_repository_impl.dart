import 'package:calculations/features/employees/data/datasources/employee_local_data_source.dart';
import 'package:calculations/features/employees/data/datasources/employee_local_data_source_impl.dart';
import 'package:calculations/features/slips/data/datasources/slip_local_data_source.dart';
import 'package:calculations/features/slips/data/datasources/slip_local_data_source_impl.dart';
import 'package:calculations/features/slips/data/model/slip_item_model.dart';
import 'package:calculations/features/slips/data/model/slip_model.dart';
import 'package:calculations/features/slips/domain/repository/slip_repository.dart';

class SlipRepositoryImpl implements SlipRepository {
  final EmployeeLocalDataSource employeeLocalDataSource =
      EmployeeLocalDataSourceImpl();
  final SlipLocalDataSource slipLocalDataSource = SlipLocalDataSourceImpl();
  @override
  Future<SlipModel> createNewSlip({
    required int employeeId,
    required double totalAmount,
    required List<SlipItemModel> slipItems,
    required String? note,
  }) async {
    final employee = await employeeLocalDataSource.getEmployee(employeeId);
    final newslip = SlipModel(
      dateTime: DateTime.now(),
      employee: employee,
      slipItems: slipItems,
      total: totalAmount,
      note: note
    );
    final id = await slipLocalDataSource.createSlip(newslip);
    return newslip.copyWith(id: id);
  }

  @override
  Future<bool> deleteSlip(int id) async {
    return await slipLocalDataSource.deleteSlip(id);
  }

  @override
  Future<SlipModel> getSlip(int id) async {
    return await slipLocalDataSource.getSlip(id);
  }

  @override
  Future<List<SlipModel>> getSlips(DateTime? dateTime) async {
    return await slipLocalDataSource.getSlips(dateTime);
  }

  @override
  Future<SlipModel> updateSlip(
    int id, {
    required int employeeId,
    required double totalAmount,
    required List<SlipItemModel> slipItems,
    required String? note,
  }) async {
    final employee = await employeeLocalDataSource.getEmployee(employeeId);
    final slip = await slipLocalDataSource.getSlip(id);

    final updatedSlip = SlipModel(
      id: id,
      employee: employee,
      dateTime: slip.dateTime, // Fallback logic
      slipItems: slipItems,
      total: totalAmount,
      note: note,
    );

    await slipLocalDataSource.updateSlip(
      updatedSlip,
    );
    return updatedSlip;
  }
}
