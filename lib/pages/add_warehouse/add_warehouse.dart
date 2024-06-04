import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/components/governorates.dart';
import 'package:masahaty/pages/add_warehouse/components/functions.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/provider/location.dart';
import 'package:masahaty/routes/routes.dart';
import 'package:masahaty/services/dio_storage.dart';
import '../../components/info_text_form_field.dart';
import '../../components/show_selection_bottomsheet.dart';
import '../../components/subtitle.dart';
import '../../core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../profile_page/components/profie_elements_data.dart';
import '../profile_page/components/settings_buttons.dart';
import 'components/add_images.dart';
import 'components/custom_radio_features.dart';
import 'components/selected_gov.dart';

class AddWarehousePost extends ConsumerStatefulWidget {
  const AddWarehousePost({super.key});

  @override
  ConsumerState<AddWarehousePost> createState() => _AddWarehousePostState();
}

class _AddWarehousePostState extends ConsumerState<AddWarehousePost> {
  get currentUserToken => ref.read(currentUserProvider)?.token;
  get currentUserId => ref.read(currentUserProvider)?.id;

  final warehouseNameController = TextEditingController();
  final warehouseDescriptionController = TextEditingController();
  final numberOfRoomsController = TextEditingController();
  final pricePerNightController = TextEditingController();
  final warehousSpaceController = TextEditingController();

  int numberOfRooms = 0;
  double pricePerNight = 0;
  double space = 0;
  String? govId;
  String? cityId;
  String? address;
  List<String> featuresIds = [];
  List<String> images = [];
  List<File> tempImages = [];
  double? warehouseLatitude = 0;
  double? warehouseLongitude = 0;

  final nameFormKey = GlobalKey<FormState>();
  final descriptionFormKey = GlobalKey<FormState>();
  final pricePerNightFormKey = GlobalKey<FormState>();
  final govFormKey = GlobalKey<FormState>();
  final cityFormKey = GlobalKey<FormState>();
  final spaceFormKey = GlobalKey<FormState>();
  final noumberOfRoomsFormKey = GlobalKey<FormState>();

  bool cooling = false;
  bool roof = false;
  bool garuded = false;
  bool safe = false;
  bool securityCameras = false;
  bool govStateIsValid = true;
  bool cityStateIsValid = true;
  String selectedGovermnt = '';
  String selectedCity = '';
  int imagesLimit = 9;
  bool isLoading = false;
  final ImagePicker imagePicker = ImagePicker();

  void selectGov() async {
    setState(() {});
    final temp = await callCustomBottomSheet(
      list: IraqiGoveronates(context).iraqStates,
      context: context,
    );
    if (temp != null) {
      setState(() {
        selectedGovermnt = temp;
        govStateIsValid = true;
      });
    } else {
      govStateIsValid = false;
    }
  }

  void selectCity() async {
    setState(() {});
    dynamic temp = [];
    temp = await callCustomBottomSheet(
      list: getCities(context, selectedGovermnt),
      context: context,
    );
    if (temp != null) {
      setState(() {
        selectedCity = temp;
        cityStateIsValid = true;
      });
    } else {
      cityStateIsValid = false;
    }
  }

  void selectImages() async {
    //.pickMultiImage(limit: imagesLimit, ImageSource.gallery);
    List<XFile>? returnedImages =
        await ImagePicker().pickMultiImage(limit: imagesLimit);
    if (returnedImages.isNotEmpty) {
      setState(() {
        for (var image in returnedImages) {
          tempImages.add(File(image.path));
        }
        imagesLimit = (7 - tempImages.length);
      });
    }
  }

  String? checkValidation(String? query) {
    if (query == '' || query == null) {
      return AppLocalizations.of(context)!.phoneNumberErrorEmpty;
    } else {
      return null;
    }
  }

  bool validateForm() {
    numberOfRooms = int.tryParse(numberOfRoomsController.text) ?? 0;
    pricePerNight = double.tryParse(pricePerNightController.text) ?? 0;
    space = double.tryParse(warehousSpaceController.text) ?? 0;
    bool isValid = true;
    if (selectedGovermnt.isEmpty == true || selectedGovermnt == null) {
      govStateIsValid == false;
      setState(() {});
      isValid == false;
    }
    if (selectedCity.isEmpty == true) {
      cityStateIsValid == false;
      setState(() {});
      isValid == false;
    }
    if (!nameFormKey.currentState!.validate()) isValid = false;
    if (!descriptionFormKey.currentState!.validate()) isValid = false;
    if (pricePerNight <= 0 && !pricePerNightFormKey.currentState!.validate()) {
      isValid = false;
    }
    if (space <= 0 && !spaceFormKey.currentState!.validate()) isValid = false;
    if (numberOfRooms <= 0 && !noumberOfRoomsFormKey.currentState!.validate()) {
      isValid = false;
    }
    if (warehouseLatitude == 0 || warehouseLatitude == null) isValid = false;
    if (warehouseLongitude == 0 || warehouseLongitude == null) isValid = false;
    if (address == null) isValid = false;
    if (tempImages.length < 3) isValid = false;
    return isValid;
  }

  void postWarehouse() async {
    setState(() => isLoading = true);
      govId = await getGovId(context, selectedGovermnt);

    dynamic temp;
      temp = await getCityId(context, selectedCity, selectedGovermnt);
    address = temp?['name'];
    cityId = temp?['id'];
    if (validateForm()) {
      featuresIds = await getFeaturesIds(
        cooling: cooling,
        roof: roof,
        garuded: garuded,
        safe: safe,
        securityCameras: securityCameras,
      );
      final storageService = StorageService();
      images = await uploadImages(tempImages, currentUserToken);
      storageService.storagePost(
          token: currentUserToken,
          name: warehouseNameController.text,
          description: warehouseDescriptionController.text,
          price: pricePerNight,
          numberOfRooms: numberOfRooms,
          space: space,
          latitude: warehouseLatitude!,
          longitude: warehouseLongitude!,
          govId: govId!,
          cityId: cityId!,
          address: address!,
          featuresIds: featuresIds,
          images: images);
      setState(() => isLoading = false);
      context.pop();
    } else {
      print('try again');
      setState(() => isLoading = false);
    }
  }

  void go() => context.pushNamed(Routes.profilePage);
  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(locationProvider);
    warehouseLatitude = currentLocation?.latitude;
    warehouseLongitude = currentLocation?.longitude;
    Widget previewContent;

    void getLocation() {
      ref.read(locationProvider.notifier).getCurrentLocation();
      setState(() {});
    }

    if (currentLocation == null) {
      previewContent = Text(
        AppLocalizations.of(context)!.noAddressSelected,
      );
    } else {
      previewContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${currentLocation.placemarks?.locality} - ${currentLocation.placemarks?.subLocality} - ${currentLocation.placemarks?.name}'),
          Text('${currentLocation.latitude}, ${currentLocation.longitude}'),
        ],
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: CustomPageTheme.bigPadding,
              horizontal: CustomPageTheme.normalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: CustomPageTheme.bigPadding,
              ),
              Row(
                children: [
                  const customBackButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomPageTheme.smallPadding),
                    child: Text(
                      AppLocalizations.of(context)!.addPost,
                      style:
                          const TextStyle(fontSize: CustomFontsTheme.bigSize),
                    ),
                  )
                ],
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.warehouseName),
              InfoTextField(
                controller: warehouseNameController,
                formKey: nameFormKey,
                validator: checkValidation,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.warehouseDiscription),
              InfoTextField(
                maxLines: 4,
                controller: warehouseDescriptionController,
                formKey: descriptionFormKey,
                validator: checkValidation,
              ),
              SubTitle(
                  ttt: AppLocalizations.of(context)!.warehousePricePerNight),
              InfoTextField(
                controller: pricePerNightController,
                keyboardType: TextInputType.number,
                formKey: pricePerNightFormKey,
                validator: checkValidation,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.governorate),
              SelectGov(
                onTap: selectGov,
                selectedGovermnt: selectedGovermnt,
                stateIsValid: govStateIsValid,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.theCity),
              SelectGov(
                onTap: selectCity,
                selectedGovermnt: selectedCity,
                stateIsValid: cityStateIsValid,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.warehousePictures),
              AddImages(
                imagesLimit: imagesLimit,
                selectImages: selectImages,
                selectedImages: tempImages,
              ),
              const SizedBox(
                height: 16,
              ),
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
                formKey: noumberOfRoomsFormKey,
                validator: checkValidation,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.space),
              InfoTextField(
                keyboardType: TextInputType.number,
                controller: warehousSpaceController,
                formKey: spaceFormKey,
                validator: checkValidation,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.cooling),
              CustomRadioFeatures(
                onChange: (value) => cooling = value,
                val: cooling,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.roof),
              CustomRadioFeatures(
                onChange: (value) => roof = value,
                val: roof,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.secured),
              CustomRadioFeatures(
                onChange: (value) => garuded = value,
                val: garuded,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.safe),
              CustomRadioFeatures(
                onChange: (value) => safe = value,
                val: safe,
              ),
              SubTitle(ttt: AppLocalizations.of(context)!.securityCameras),
              CustomRadioFeatures(
                onChange: (value) => securityCameras = value,
                val: securityCameras,
              ),
              const SizedBox(
                height: CustomPageTheme.normalPadding,
              ),
              Container(
                alignment: Alignment.center,
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: previewContent,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: CustomPageTheme.normalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CoustomBorderTheme.normalBorderRaduis))),
                      onPressed: getLocation,
                      child: isLoading == false
                          ? Text(AppLocalizations.of(context)!.yourCurrentLocation)
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                                      ),
                    ),
                    const SizedBox(width: CustomPageTheme.normalPadding,),
                    Expanded(
                      child: ElevatedButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CoustomBorderTheme.normalBorderRaduis))),
                      onPressed: (){},
                      child: isLoading == false 
                          ? Text(AppLocalizations.of(context)!.map)
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                                      ),
                    ),
                  ],
                ),
              ),
              if (currentUserId != null)
                ElevatedButton(
                  style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CoustomBorderTheme.normalBorderRaduis))),
                  onPressed: postWarehouse,
                  child: isLoading == false
                      ? Text(AppLocalizations.of(context)!.postWarehouse)
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              if (currentUserId == null)
                SettingsButtons(suffixIcon: const Icon(null), buttonsStyles: [
                  ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          CustomColorsTheme.unAvailableRadioColor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CoustomBorderTheme.normalBorderRaduis),
                        ),
                      ),
                      side: WidgetStateProperty.all(const BorderSide(
                          width: 1.5,
                          color: CustomColorsTheme.unAvailableRadioColor))),
                ], buttonsFunctions: [
                  go
                ], buttonsPrefixIcons: const [
                  Icon(Icons.login)
                ], buttonsText: [
                  AppLocalizations.of(context)!.signIn
                ]),
            ],
          ),
        ),
      ),
    );
  }
}
