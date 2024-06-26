import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/components/warehouse_card_skeleton.dart';
import 'package:masahaty/models/storage&features_model.dart';
import 'package:masahaty/services/api/dio_storage.dart';
import '../../components/custom_back_botton.dart';
import '../../components/warehouse_card.dart';
import '../../core/constants/constants.dart';
import '../../provider/current_user.dart';

class MyPostPage extends ConsumerStatefulWidget {
  const MyPostPage({super.key});

  @override
  ConsumerState<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends ConsumerState<MyPostPage> {
  late String? currentUserId = ref.read(currentUserProvider)?.id;
  List<Storage> currentPosts = [];
  StorageService storageService = StorageService();
  bool isLoading = false;

  void getOrders() async {
    setState(() => isLoading = true);
    final storages = await storageService.storageGet();
    for (Storage storage in storages) {
      if (storage.owner.id == currentUserId) {
        currentPosts.add(storage);
      }
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const SingleChildScrollView(
        child:  Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WarehouseCardSkeleton(),
              WarehouseCardSkeleton(),
              WarehouseCardSkeleton()
            ],
          ),
        ),
      );
    } else if (currentPosts.isEmpty) {
      content = Center(
        child: Text(
            "${AppLocalizations.of(context)!.myPosts} ${AppLocalizations.of(context)!.empty}"),
      );
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomPageTheme.normalPadding),
        itemCount: currentPosts.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: CustomPageTheme.normalPadding,
        ),
        itemBuilder: (context, index) {
          if (currentPosts.isEmpty) {
            return const Center(child: Text('em'));
          } else {
            return WarehouseCard(
                rating: currentPosts[index].rating,
                id: currentPosts[index].id,
                governorate: currentPosts[index].city!.govName,
                district: currentPosts[index].city!.name,
                title: currentPosts[index].name,
                discription: currentPosts[index].description,
                imagePath: currentPosts[index].images[0],
                price: currentPosts[index].price);
          }
        },
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorsTheme.scaffoldBackGroundColor,
          leading: const Padding(
            padding: EdgeInsets.all(CustomPageTheme.smallPadding),
            child: CustomBackButton(),
          ),
          title: Text(AppLocalizations.of(context)!.myPosts),
          centerTitle: true,
        ),
        body: content);
  }
}
