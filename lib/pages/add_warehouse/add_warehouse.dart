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
import 'package:masahaty/services/dio_features.dart';
import 'package:masahaty/services/dio_storage.dart';
import '../../components/info_text_form_field.dart';
import '../../components/show_selection_bottomsheet.dart';
import '../../components/subtitle.dart';
import '../../core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../services/dio_govs&cities.dart';
import '../profile_page/components/profie_elements_data.dart';
import '../profile_page/components/settings_buttons.dart';
import 'components/add_images.dart';
import '../../components/custom_chips.dart';
import 'components/custom_radio_features.dart';
import 'components/selected_gov.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  int numberOfRooms = 0;
  final pricePerNightController = TextEditingController();
  double pricePerNight = 0;
  final warehousSpaceController = TextEditingController();
  double space = 0;
  String? govId = '';
  String cityId = '';
  String address = '';
  List<String> featuresIds = [];
  List<String> images = [];
  double? warehouseLatitude = 0;
  double? warehouseLongitude = 0;
  final nameFormKey = GlobalKey<FormState>();
  final descriptionFormKey = GlobalKey<FormState>();
  final pricePerNightFormKey = GlobalKey<FormState>();
  final govFormKey = GlobalKey<FormState>();
  final cityFormKey = GlobalKey<FormState>();
  final spaceFormKey = GlobalKey<FormState>();
  final noumberOfRoomsFormKey = GlobalKey<FormState>();
  List<File> tempImages = [];
  bool cooling = false;
  bool roof = false;
  bool garuded = false;
  bool safe = false;
  bool securityCameras = false;
  bool govStateIsValid = true;
  String selectedGovermnt = '';
  String selectedCity = '';
  int imagesLimit = 9;
  bool isLoading = false;
  final ImagePicker imagePicker = ImagePicker();
  final featuresService = FeaturesService();
  final storageService = StorageService();
  final govs = Govs();

  void selectGov() async {
    final temp = await callCustomBottomSheet(
      list: IraqiGoveronates(context).iraqStates,
      context: context,
    );
    if (temp != null) {
      setState(() {
        selectedGovermnt = temp;
        selectedCity = '';
      });
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
      });
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
    if (selectedGovermnt.isEmpty != true) {
      setState(() {
        govStateIsValid == false;
      });
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
    if (address.isEmpty) isValid = false;
    if (tempImages.length < 3) isValid = false;

    return isValid;
  }
  void postWarehouse() async {
    setState(()=>isLoading = true);
    govId = await getGovId(context, selectedGovermnt);
    final temp = await getCityId(context, selectedCity, selectedGovermnt);
    address = temp?['name'];
    cityId = temp?['id'];
    if (validateForm()) {
      print('ff');
      featuresIds = await getFeaturesIds(
        cooling: cooling,
        roof: roof,
        garuded: garuded,
        safe: safe,
        securityCameras: securityCameras,
      );
      images = await uploadImages(tempImages, currentUserToken);
      print(featuresIds);
      print(govId);
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
          cityId: cityId,
          address: address,
          featuresIds: featuresIds,
          images: images);
         setState(()=>isLoading = false);
      context.pop();
    } else {
      print('try again');
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
      body: ModalProgressHUD(
        inAsyncCall:isLoading ,
        child: SingleChildScrollView(
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
                  stateIsValid: govStateIsValid,
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
                CustomChips(
                    featuresChipsPics: CustomChipsData(context).featuresChipsPics,
                    featuresChipText: CustomChipsData(context).featuresChipText),
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
                SubTitle(ttt: AppLocalizations.of(context)!.moneySafe),
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
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        10), // Update with your preferred radius
                    border: Border.all(
                      color: Colors.grey, // Update with your preferred color
                      width: 2,
                    ),
                  ),
                  child: previewContent,
                ),
                SettingsButtons(
                  padding: const EdgeInsets.all(0),
                  buttonsFunctions: [getLocation],
                  buttonsText: [AppLocalizations.of(context)!.autoLocate],
                  buttonsPrefixIcons: const [Icon(null)],
                  buttonsStyles: [
                    ButtonsData(context).buttonsStyles[0],
                  ],
                ),
                if (currentUserId != null)
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                CoustomBorderTheme.normalBorderRaduis))),
                    onPressed: postWarehouse,
                    child: Text(AppLocalizations.of(context)!.postWarehouse),
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
      ),
    );
  }
}
