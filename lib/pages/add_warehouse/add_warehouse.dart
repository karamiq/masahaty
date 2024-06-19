import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/components/governorates.dart';
import 'package:masahaty/models/location_model.dart';
import 'package:masahaty/pages/add_warehouse/components/functions.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/provider/location.dart';
import 'package:masahaty/routes/routes.dart';
import 'package:masahaty/services/api/dio_storage.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/info_text_form_field.dart';
import '../../components/show_selection_bottomsheet.dart';
import '../../components/subtitle.dart';
import '../../core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'components/add_images.dart';
import 'components/custom_radio_features.dart';
import 'components/map_info.dart';
import 'components/selected_gov.dart';

class AddWarehousePost extends ConsumerStatefulWidget {
  const AddWarehousePost({super.key});

  @override
  ConsumerState<AddWarehousePost> createState() => _AddWarehousePostState();
}

class _AddWarehousePostState extends ConsumerState<AddWarehousePost> {
  get currentUserToken => ref.read(currentUserProvider)?.token;
  get currentUserId => ref.read(currentUserProvider)?.id;
  get currentLocation => ref.watch(locationProvider);
  final warehouseNameController = TextEditingController();
  final warehouseDescriptionController = TextEditingController();
  final numberOfRoomsController = TextEditingController();
  final pricePerNightController = TextEditingController();
  final warehouseSpaceController = TextEditingController();
  List<File> tempImages = [];
  LocationService? storageLocation;
  final _formKey = GlobalKey<FormState>();

  bool cooling = false;
  bool roof = false;
  bool guarded = false;
  bool safe = false;
  bool securityCameras = false;
  bool govStateIsValid = true;
  bool cityStateIsValid = true;
  String selectedGoverment = '';
  String selectedCity = '';
  int imagesLimit = 9;
  bool isLoading = false;
  bool isAddressSelected = true;
  bool isLoadCurrentLocation = false;

  void selectGov() async {
    final temp = await callCustomBottomSheet(
      list: IraqiGoveronates(context).iraqStates,
      context: context,
    );
    if (temp != null) {
      setState(() {
        selectedGoverment = temp;
        govStateIsValid = true;
      });
    } else {
      setState(() {
        govStateIsValid = false;
      });
    }
  }

  void selectCity() async {
    final temp = await callCustomBottomSheet(
      list: getCities(context, selectedGoverment),
      context: context,
    );
    if (temp != null) {
      setState(() {
        selectedCity = temp;
        cityStateIsValid = true;
      });
    } else {
      setState(() {
        cityStateIsValid = false;
      });
    }
  }

  void selectImages() async {
    final ImagePicker imagePicker = ImagePicker();
    final returnedImages = await imagePicker.pickMultiImage();
    if (returnedImages != null) {
      setState(() {
        tempImages.addAll(returnedImages.map((image) => File(image.path)));
        imagesLimit = 9 - tempImages.length;
      });
    }
  }

  String? checkValidation(String? query) {
    if (query == null || query.isEmpty) {
      return AppLocalizations.of(context)!.phoneNumberErrorEmpty;
    }
    return null;
  }

  bool validateForm() {
    final numberOfRooms = int.tryParse(numberOfRoomsController.text) ?? 0;
    final pricePerNight = double.tryParse(pricePerNightController.text) ?? 0;
    final space = double.tryParse(warehouseSpaceController.text) ?? 0;
    bool isValid = true;
    if (storageLocation == null) {
      setState(() => isAddressSelected = false);
      isValid = false;
    }else{setState(() =>isAddressSelected = true);}
    if (selectedGoverment.isEmpty) {
      setState(() => govStateIsValid = false);
      isValid = false;
    }
    if (selectedCity.isEmpty) {
      setState(() => cityStateIsValid = false);
      isValid = false;
    }
    if (!_formKey.currentState!.validate()) isValid = false;
    if (pricePerNight <= 0) isValid = false;
    if (space <= 0) isValid = false;
    if (numberOfRooms <= 0) isValid = false;
    if (tempImages.length < 3) isValid = false;

    return isValid;
  }

  void postWarehouse() async {
    if (!validateForm()) {
      print('Form validation failed');
      return;
    }
    setState(() => isLoading = true);
    try {
      final govId = await getGovId(context, selectedGoverment);
      final cityInfo =
          await getCityId(context, selectedCity, selectedGoverment);
      final address = cityInfo?['name'];
      final cityId = cityInfo?['id'];
      final featuresIds = await getFeaturesIds(
        cooling: cooling,
        roof: roof,
        garuded: guarded,
        safe: safe,
        securityCameras: securityCameras,
      );
      final storageService = StorageService();
      final images = await uploadImages(tempImages, currentUserToken);

      await storageService.storagePost(
        token: currentUserToken,
        name: warehouseNameController.text,
        description: warehouseDescriptionController.text,
        price: double.parse(pricePerNightController.text),
        numberOfRooms: int.parse(numberOfRoomsController.text),
        space: double.parse(warehouseSpaceController.text),
        latitude: storageLocation!.latitude!,
        longitude: storageLocation!.longitude!,
        govId: govId!,
        cityId: cityId!,
        address: address!,
        featuresIds: featuresIds,
        images: images,
      );

      setState(() => isLoading = false);
      context.pop();
    } catch (error) {
      setState(() => isLoading = false);
    }
  }

  void pickLocation() async {
    final returnedLocation =
        await context.pushNamed<LocationService?>(Routes.pickLocation);
    if (returnedLocation != null) {
      storageLocation = returnedLocation;
      setState(() {});
    }
  }

  void getLocation() async {
    ref.watch(locationProvider.notifier).getCurrentLocation();
    setState(() {
      isLoadCurrentLocation = true;
    });
    final currentLocation = ref.watch(locationProvider);
    if (currentLocation != null) {
      storageLocation = currentLocation;
      setState(() => isLoadCurrentLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: CustomPageTheme.bigPadding,
          horizontal: CustomPageTheme.normalPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: CustomPageTheme.bigPadding),
              Row(
                children: [
                  const CustomBackButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomPageTheme.smallPadding),
                    child: Text(
                      AppLocalizations.of(context)!.addPost,
                      style:
                          const TextStyle(fontSize: CustomFontsTheme.bigSize),
                    ),
                  ),
                ],
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.warehouseName),
              InfoTextField(
                controller: warehouseNameController,
                validator: checkValidation,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.warehouseDiscription),
              InfoTextField(
                maxLines: 4,
                controller: warehouseDescriptionController,
                validator: checkValidation,
              ),
              SubTitle(
                  ttt: AppLocalizations.of(context)!.warehousePricePerNight),
              InfoTextField(
                controller: pricePerNightController,
                keyboardType: TextInputType.number,
                validator: checkValidation,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.governorate),
              SelectGov(
                onTap: selectGov,
                selectedGoverment: selectedGoverment,
                stateIsValid: govStateIsValid,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.theCity),
              SelectGov(
                onTap: selectCity,
                selectedGoverment: selectedCity,
                stateIsValid: cityStateIsValid,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.warehousePictures),
              AddImages(
                imagesLimit: imagesLimit,
                selectImages: selectImages,
                selectedImages: tempImages,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.warehouseAddThreePicsAtLeast,
                style:
                    const TextStyle(color: CustomColorsTheme.descriptionColor),
              ),
              const SizedBox(height: 30),
              SubTitle(ttt: AppLocalizations.of(context)!.numberOfRooms),
              InfoTextField(
                controller: numberOfRoomsController,
                keyboardType: TextInputType.number,
                validator: checkValidation,
              ),
              SubTitle(
                  ttt:
                      "${AppLocalizations.of(context)!.space} ${AppLocalizations.of(context)!.m}"),
              InfoTextField(
                keyboardType: TextInputType.number,
                controller: warehouseSpaceController,
                validator: checkValidation,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.cooling),
              CustomRadioFeatures(
                onChange: (value) => setState(() => cooling = value),
                val: cooling,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.roof),
              CustomRadioFeatures(
                onChange: (value) => setState(() => roof = value),
                val: roof,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.secured),
              CustomRadioFeatures(
                onChange: (value) => setState(() => guarded = value),
                val: guarded,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.safe),
              CustomRadioFeatures(
                onChange: (value) => setState(() => safe = value),
                val: safe,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.securityCameras),
              CustomRadioFeatures(
                onChange: (value) => setState(() => securityCameras = value),
                val: securityCameras,
              ),
              const SizedBox(height: CustomPageTheme.normalPadding),
              MapInfo(
                addressSelected: isAddressSelected,
                loadCurrentLocation: isLoading,
                storageLocation: storageLocation,
                isLoading: isLoading,
                getLocation: getLocation,
                pickLocation: pickLocation,
              ),
              if (currentUserId != null)
                CustomElevatedButton(
                  onPressed: postWarehouse,
                  label: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(AppLocalizations.of(context)!.postWarehouse),
                ),
              if (currentUserId == null)
                CustomElevatedButton(
                  label: Text(AppLocalizations.of(context)!.signIn),
                  backgroundColor: CustomColorsTheme.unAvailableRadioColor,
                  onPressed: () => context.pushNamed(Routes.logIn),
                  icon: const Icon(Icons.login),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
