import 'package:calculations/core/database/database_helper.dart'; // Adjust path
import 'package:calculations/features/slips/data/datasources/slip_local_data_source.dart';
import 'package:calculations/features/slips/data/model/slip_model.dart';

class SlipLocalDataSourceImpl implements SlipLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Future<int> createSlip(SlipModel slip) async {
    final db = await dbHelper.database;

    return await db.transaction((txn) async {
      // 1. Insert the main slip (Header)
      int slipId = await txn.insert('slips', slip.toMap());

      // 2. Insert each calculation step linked to this slipId
      for (var slipItem in slip.slipItems) {
        await txn.insert('slip_items', {
          'slip_id': slipId,
          'product_name': slipItem.productName,
          'kg': slipItem.kg,
          'per_kg': slipItem.perKg,
          'row_total': slipItem.rowTotal,
        });
      }
      return slipId;
    });
  }

  @override
  Future<List<SlipModel>> getSlips() async {
    final db = await dbHelper.database;

    // Join with employee to get the name for the Employee entity
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT slips.*, employee.name as employee_name, employee.number as employee_number
      FROM slips
      INNER JOIN employee ON slips.employee_id = employee.id
    ''');

    List<SlipModel> slips = [];

    for (var map in maps) {
      // For each slip, we must fetch its specific items
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'slip_items',
        where: 'slip_id = ?',
        whereArgs: [map['id']],
      );

      // Reconstruct steps and employee to create the SlipModel
      // Note: You'll need to implement mapping logic for these sub-entities
      slips.add(SlipModel.fromMap(map, itemMaps)); 
    }

    return slips;
  }

  @override
  Future<SlipModel> getSlip(int id) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'slips',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final itemMaps = await db.query('slip_items', where: 'slip_id = ?', whereArgs: [id]);
      // Assuming you have an Employee lookup logic here
      return SlipModel.fromMap(maps.first, itemMaps);
    } else {
      throw Exception("Slip not found");
    }
  }

  @override
  Future<bool> deleteSlip(int id) async {
    final db = await dbHelper.database;
    // Because of ON DELETE CASCADE in our table definition, 
    // deleting the slip will automatically delete its items.
    int result = await db.delete(
      'slips',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<int> updateSlip(SlipModel slip) async {
    final db = await dbHelper.database;

    return await db.transaction((txn) async {
      // 1. Update the main slip
      await txn.update(
        'slips',
        slip.toMap(),
        where: 'id = ?',
        whereArgs: [slip.id],
      );

      // 2. Simplest way to update items: Delete old ones and insert new ones
      await txn.delete('slip_items', where: 'slip_id = ?', whereArgs: [slip.id]);
      for (var step in slip.slipItems) {
        await txn.insert('slip_items', {
          'slip_id': slip.id,
          'product_name': step.productName,
          'kg': step.kg,
          'per_kg': step.perKg,
          'row_total': step.rowTotal,
        });
      }
      return slip.id ?? 0;
    });
  }
}