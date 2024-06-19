import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/routes/routes.dart';
import '../../components/auth_page_head.dart';
import '../../components/custom_text_from_field.dart';
import '../../models/user_model.dart';
import '../../provider/current_user.dart';
import '../../services/api/dio_auth.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  dynamic phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController(text: '077');
  }

  @override
  Widget build(BuildContext context) {

    void register() async {
      if (formKey.currentState!.validate()) {
        setState(()=> isLoading = true);
        final response = await AuthService.register(
            phoneNumber: phoneNumberController.text,
            fullName: fullNameController.text);
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
              content: Text(
                AppLocalizations.of(context)!.phoneNumberIsUsed,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        
        setState(()=> isLoading = false);
      }
    }

    String? validatePhoneNumber(String? query) {
      if (query == null || query.isEmpty) {
        return AppLocalizations.of(context)!.phoneNumberErrorEmpty;
      } else if (query.length <= 9) {
        return AppLocalizations.of(context)!.phoneNumberErrorLength;
      } else {
        return null;
      }
    }

    String? validateUserName(String? query) {
      if (query == null || query.isEmpty) {
        return AppLocalizations.of(context)!.phoneNumberErrorEmpty;
      } else {
        return null;
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
            child: Form(
              key: formKey,
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
                      controller: fullNameController,
                      validator: validateUserName),
                  const SizedBox(
                    height: CustomPageTheme.normalPadding,
                  ),
                  CustomTextFormField(
                    keyBoardType: TextInputType.phone,
                    labelText: AppLocalizations.of(context)!.phoneNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
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
                            onPressed:!isLoading ? () => context.pushNamed(Routes.logIn): null,
                            child: Text(
                              AppLocalizations.of(context)!.signIn,
                              style: const TextStyle(
                                color: CustomColorsTheme.headLineColor,
                                fontWeight: CustomFontsTheme.bigWeight,
                              ),
                            ),
                    )
                    ],
                    ),
                  ),
                ],
              ),
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
              child: !isLoading
                  ? Text(AppLocalizations.of(context)!.createAccount)
                  : const CircularProgressIndicator(backgroundColor: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
