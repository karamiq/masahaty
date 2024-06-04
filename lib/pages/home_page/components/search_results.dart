
import 'package:flutter/material.dart';

import '../../../components/warehouse_card.dart';
import '../../../core/constants/constants.dart';
import '../../../models/storage&features_model.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key, required this.storages});

  final List<Storage>? storages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: CustomPageTheme.bigPadding),
        storages!.isEmpty
            ? const Center(child: Text('No results found'))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: storages!.length,
                itemBuilder: (context, index) {
                  Storage warehouse = storages![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomPageTheme.normalPadding),
                    child: WarehouseCard(
                        rating: warehouse.rating,
                        id: warehouse.id,
                        governorate: warehouse.city!.govName,
                        district: warehouse.city!.name,
                        title: warehouse.name,
                        discription: warehouse.description,
                        imagePath: warehouse.images[0],
                        price: warehouse.price),
                  );
                },
              ),
      ],
    );
  }
}
