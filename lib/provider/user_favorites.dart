import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/models/storage&features_model.dart';

class UserFavorites extends StateNotifier<List<Storage>> {
    UserFavorites() : super(const[]);

  void addToFavorites(Storage newWarehouse) {
    state = [newWarehouse, ...state];
  }
}
final favoritesProvider =
    StateNotifierProvider<UserFavorites, List<Storage>>((ref) => UserFavorites());