import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/all_warehouses.dart';
import '../../../provider/user_favorites.dart';

 class FavoritesService extends ConsumerState {

dynamic get allWarehouses => ref.read(allWarehousesPorvider);
dynamic get favoritesList => ref.watch(favoritesProvider);

     void addToFavorites(String wharehouseId) {
      final existingIndex = favoritesList
          .indexWhere((wharehouse) => wharehouse.id == wharehouse.id);
      if (existingIndex >= 0) {
        //i might need to use setState method
        favoritesList.removeAt(existingIndex);
      } else {
        favoritesList.add(allWarehouses
            ?.firstWhere((wharehouse) => wharehouse.id == wharehouseId));
      }
    }
    bool isFavorite(String id) {
      return allWarehouses.any((warehouse) => warehouse.id == id);
    }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  }