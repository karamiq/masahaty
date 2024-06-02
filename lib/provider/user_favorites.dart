import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/models/warehouse_model.dart';

class UserFavorites extends StateNotifier<List<Warehouse>> {
    UserFavorites() : super(const[]);

  void addToFavorites(Warehouse newWarehouse) {
    state = [newWarehouse, ...state];
  }
}
final favoritesProvider =
    StateNotifierProvider<UserFavorites, List<Warehouse>>((ref) => UserFavorites());