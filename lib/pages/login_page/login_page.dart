import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/components/uuid_shortener.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/models/user_model.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/routes/routes.dart';
import 'package:masahaty/services/api/api_service.dart';
import '../../components/auth_page_head.dart';
import '../../components/custom_text_from_field.dart';
import '../../services/api/dio_auth.dart';

Future<User>? user;
TextEditingController phoneNumberController = TextEditingController();
final formKey = GlobalKey<FormState>();

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  bool isLoading = false;
  void logIn() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      dynamic response = await AuthService.login(
        phoneNumber: phoneNumberController.text,
      );
      if (response is User) {
        final user = response;
        ref.read(currentUserProvider.notifier).changeUser(user);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.successedLogin,
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go(Routes.tabsPage);
      } else if (response == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.notExistingUser,),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumberController = TextEditingController(text: '077');
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
        child: Form(
          key: formKey,
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
                      validator: validatePhoneNumber,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.youAreNewUser,
                          style: const TextStyle(
                            color: CustomColorsTheme.descriptionColor,
                            fontWeight: CustomFontsTheme.bigWeight,
                          ),
                        ),
                        TextButton(
                            onPressed: () =>
                                context.pushNamed(Routes.registerPage),
                            child: Text(
                              AppLocalizations.of(context)!.createAccount,
                              style: const TextStyle(
                                color: CustomColorsTheme.headLineColor,
                                fontWeight: CustomFontsTheme.bigWeight,
                              ),
                            )),
                      ],
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
                  onPressed: !isLoading ? logIn : null,
                  child: !isLoading
                      ? Text(AppLocalizations.of(context)!.signIn)
                      : const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
