import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/models/storage&features_model.dart';

class AllWarehousesNotifier extends StateNotifier<List<Storage>?> {
  AllWarehousesNotifier() : super(const []);

   Future<void> getAllWarehouses(List<Storage>? list) async {
    state = list;
  }
}
final allWarehousesPorvider =
    StateNotifierProvider<AllWarehousesNotifier, List<Storage>?>(
        (ref) => AllWarehousesNotifier());
