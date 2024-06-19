import 'package:flutter/material.dart';
import '../../../components/custom_elevated_button.dart';
import '../../../core/constants/constants.dart';
import '../../../models/location_model.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MapInfo extends StatelessWidget {
  const MapInfo({
    super.key,
    required this.addressSelected,
    required this.loadCurrentLocation,
    required this.storageLocation,
    required this.isLoading,
    required this.getLocation,
    required this.pickLocation,
  });

  final bool addressSelected;
  final bool loadCurrentLocation;
  final LocationService? storageLocation;
  final bool isLoading;

  final Function() getLocation;
  final Function() pickLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: addressSelected ? Colors.grey : CustomColorsTheme.unAvailableRadioColor,
              width: 2,
            ),
          ),
          child: loadCurrentLocation
              ? const CircularProgressIndicator()
              : storageLocation == null
                  ? Text(AppLocalizations.of(context)!.noAddressSelected)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${storageLocation?.placemarks?.locality} - ${storageLocation?.placemarks?.subLocality} - ${storageLocation?.placemarks?.name}',
                        ),
                        Text(
                          '${storageLocation?.latitude}, ${storageLocation?.longitude}',
                        ),
                      ],
                    ),
        ),
        if (!addressSelected)
          Padding(
            padding: const EdgeInsets.all(CustomPageTheme.smallPadding),
            child: Text(
              AppLocalizations.of(context)!.phoneNumberErrorEmpty,
              style: const TextStyle(color: CustomColorsTheme.unAvailableRadioColor),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: CustomPageTheme.normalPadding),
          child: Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  onPressed: !isLoading && !loadCurrentLocation ? getLocation : null,
                  label: Text(AppLocalizations.of(context)!.yourCurrentLocation),
                ),
              ),
              const SizedBox(width: CustomPageTheme.normalPadding),
              Expanded(
                child: CustomElevatedButton(
                  onPressed: !isLoading && !loadCurrentLocation ? pickLocation : null,
                  label: Text(AppLocalizations.of(context)!.map),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}