import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/models/warehouse_model.dart';

class AllWarehousesNotifier extends StateNotifier<List<Warehouse>?> {
  AllWarehousesNotifier() : super(const []);

   Future<void> getAllWarehouses(List<Warehouse>? list) async {
    state = list;
  }
}
final allWarehousesPorvider =
    StateNotifierProvider<AllWarehousesNotifier, List<Warehouse>?>(
        (ref) => AllWarehousesNotifier());
