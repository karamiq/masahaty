import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/constants.dart';
import '../provider/all_warehouses.dart';
import '../provider/user_favorites.dart';

class CustomFavoritesButton extends ConsumerStatefulWidget {
  
  final String id;

  const CustomFavoritesButton({super.key, required this.id});

  @override
  ConsumerState<CustomFavoritesButton> createState() => _CustomFavoritesButtonState();
}

class _CustomFavoritesButtonState extends ConsumerState<CustomFavoritesButton> {
  @override
  Widget build(BuildContext context) {
    dynamic allWarehouses = ref.watch(allWarehousesPorvider);
    dynamic favoritesList = ref.watch(favoritesProvider);
    void addToFavorites(String wharehouseId) {
      final existingIndex = favoritesList
          .indexWhere((wharehouse) => wharehouse.id == wharehouseId);
      if (existingIndex >= 0) {
        //i might need to use setState method
        setState(() {
          favoritesList.removeAt(existingIndex);
        });
      } else {
        final temp = (allWarehouses
            .firstWhere((wharehouse) => wharehouse.id == wharehouseId));
        ref.read(favoritesProvider.notifier).addToFavorites(temp);
      }
    }
    bool isFavorite(String id) {
        return favoritesList!.any((warehouse) => warehouse.id == id);
    }
    void add() {
      addToFavorites(widget.id);
    }
    return IconButton(
      onPressed: add,
      icon: isFavorite(widget.id) ?  const Icon(Icons.bookmark, color: CustomColorsTheme.starColor,) : const Icon(Icons.bookmark_outline) ,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              CoustomBorderTheme.normalBorderRaduis,
            ),
            side: const BorderSide(
              width: 1,
              color: CustomColorsTheme.dividerColor,
            ),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
