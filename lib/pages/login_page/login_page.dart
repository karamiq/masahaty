import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/components/uuid_shortener.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/models/current_user.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/routes/routes.dart';
import 'package:masahaty/services/api_service.dart';
import '../../components/auth_page_head.dart';
import '../../components/custom_text_from_field.dart';
import '../../services/dio_auth.dart';

Future<UserInfo>? user;
final phoneNumberController = TextEditingController();
final phoneNumberFormKey = GlobalKey<FormState>();

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
   void logIn() async {
    if (phoneNumberFormKey.currentState!.validate()) {
      try {
        final response = await AuthService.login(
          phoneNumber: phoneNumberController.text,
        );
        if (response.statusCode == 200) {
          final data = response.data;
          if (data != null &&
              data[ApiKey.id] != null &&
              data[ApiKey.fullName] != null &&
              data[ApiKey.phoneNumber] != null &&
              data[ApiKey.role] != null &&
              data[ApiKey.token] != null) {
            var uuid = UuidShortener.convertToShortUuid((response.data['id']));
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
                  AppLocalizations.of(context)!.successedLogin,
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
                response.statusMessage ??
                    AppLocalizations.of(context)!.failedLogin,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedLogin,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    String? validatePhoneNumber(String? query) {
      if (query == null || query.isEmpty) {
        return AppLocalizations.of(context)!.phoneNumberErrorEmpty;
      } else if (RegExp(r'[a-zA-Z]').hasMatch(query)) {
        return AppLocalizations.of(context)!.phoneNumberErrorcodes;
      } else if (query.length <= 9) {
        return AppLocalizations.of(context)!.phoneNumberErrorLength;
      } else {
        return null;
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHead(),
            const SizedBox(height: CustomPageTheme.veryBigpadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: CustomPageTheme.normalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.signIn,
                    style: const TextStyle(
                        color: CustomColorsTheme.headLineColor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 6),
                  CustomTextFormField(
                    keyBoardType: TextInputType.phone,
                    labelText: AppLocalizations.of(context)!.phoneNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    controller: phoneNumberController,
                    formKey: phoneNumberFormKey,
                    validator: validatePhoneNumber,
                  ),
                  const SizedBox(height: CustomPageTheme.bigPadding),
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(
                              indent: 20, endIndent: 10, color: Colors.grey)),
                      Text(AppLocalizations.of(context)!.or),
                      const Expanded(
                          child: Divider(
                              indent: 10, endIndent: 20, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: CustomPageTheme.bigPadding),
                  Center(
                    child: TextButton(
                      onPressed: () => context.pushNamed(Routes.registerPage),
                      child: Text(
                        AppLocalizations.of(context)!.createAccount,
                        style: const TextStyle(
                          color: CustomColorsTheme.headLineColor,
                          fontWeight: CustomFontsTheme.bigWeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: CustomPageTheme.bigPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CoustomBorderTheme.normalBorderRaduis))),
                onPressed: logIn,
                child: Text(AppLocalizations.of(context)!.signIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
