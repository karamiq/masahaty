import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/routes/routes.dart';

import '../../components/auth_page_head.dart';
import '../../components/custom_text_from_field.dart';
import '../../components/uuid_shortener.dart';
import '../../models/current_user.dart';
import '../../provider/current_user.dart';
import '../../services/api_service.dart';
import '../../services/dio_auth.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberformKey = GlobalKey<FormState>();
  final nameFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    bool isValid = true;
    String? validatePhoneNumber(String? query) {
      if (query == null || query.isEmpty) {
        return AppLocalizations.of(context)!.phoneNumberErrorEmpty;
      } else {
        return null;
      }
    }

    bool validateForm() {
      if (phoneNumberformKey.currentState!.validate()) isValid = true;
      if (nameFormKey.currentState!.validate()) isValid = true;

      return isValid;
    }

    void register() async {
      if (validateForm() != false) {try {
        final response = await AuthService.register(
          phoneNumber: phoneNumberController.text,
          fullName: fullNameController.text
        );
        if (response?.statusCode == 200) {
          final data = response?.data;
          if (data != null &&
              data[ApiKey.id] != null &&
              data[ApiKey.fullName] != null &&
              data[ApiKey.phoneNumber] != null &&
              data[ApiKey.role] != null &&
              data[ApiKey.token] != null) {
            var uuid = UuidShortener.convertToShortUuid((response?.data['id']));
            final user = UserInfo(
              id: data[ApiKey.id],
              shortId: uuid,
              fullName: data[ApiKey.fullName],
              phoneNumber: data[ApiKey.phoneNumber],
              role: data[ApiKey.role],
              token: data[ApiKey.token],
            );
            ref.read(currentUserProvider.notifier).changeUser(user);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.successedRegister,
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else {
            throw Exception("Incomplete user data received");
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response?.statusMessage ??
                    AppLocalizations.of(context)!.failedRegister,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
      }
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHead(),
          const SizedBox(
            height: CustomPageTheme.veryBigpadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CustomPageTheme.normalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.createAccount,
                  style: const TextStyle(
                      color: CustomColorsTheme.headLineColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 12),
                CustomTextFormField(
                    labelText: AppLocalizations.of(context)!.fullName,
                    prefixIcon: const Icon(Icons.perm_identity),
                    formKey: nameFormKey,
                    controller: fullNameController,
                    validator: validatePhoneNumber),
                const SizedBox(
                  height: CustomPageTheme.normalPadding,
                ),
                CustomTextFormField(
                  keyBoardType: TextInputType.phone,
                  labelText: AppLocalizations.of(context)!.phoneNumber,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  formKey: phoneNumberformKey,
                  controller: phoneNumberController,
                  validator: validatePhoneNumber,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                            AppLocalizations.of(context)!.doYouHaveAnAccount,
                            style: const TextStyle(
                              color: CustomColorsTheme.descriptionColor,
                              fontWeight: CustomFontsTheme.bigWeight,
                            ),
                          ),
                      TextButton(
                          onPressed: () => context.pushNamed(Routes.logIn),
                          child: Text(
                            AppLocalizations.of(context)!.signIn,
                            style: const TextStyle(
                              color: CustomColorsTheme.headLineColor,
                              fontWeight: CustomFontsTheme.bigWeight,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: CustomPageTheme.bigPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          CoustomBorderTheme.normalBorderRaduis))),
              onPressed: register,
              child: isLoading == false
                  ? Text(AppLocalizations.of(context)!.createAccount)
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
