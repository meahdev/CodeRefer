import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lolo_bloc/application/bloc/login/login_bloc.dart';
import 'package:lolo_bloc/application/cubit/language/language_cubit.dart';
import 'package:lolo_bloc/core/app_constants.dart';
import 'package:lolo_bloc/core/app_routes.dart';
import 'package:lolo_bloc/core/app_storage.dart';
import 'package:lolo_bloc/domain/core/di/injectable_config.dart';
import 'package:lolo_bloc/presenation/login/widgets/mobile_widget.dart';

import '../../core/app_colors.dart';
import 'widgets/password_widget.dart';
import '../widgets/solid_rounded_elevated_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginBloc loginBloc = LoginBloc();
  final key = GlobalKey<ScaffoldMessengerState>();
  AppStorage appStorage = getIt<AppStorage>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: key,
        backgroundColor: Colors.white,
        body: smallScreenView(context),
      ),
    );
  }

  smallScreenView(BuildContext context) {
    print('language code is ${appStorage.getLanguageCode}');
    return SafeArea(
      child: Container(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      if (appStorage.getLanguageCode != AppConstants.english) {
                        appStorage.setLanguageCode = AppConstants.english;
                        context.read<LanguageCubit>().onLanguageChange(
                            languageCode: AppConstants.english);
                      }
                    },
                    child: const Text("English")),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                    onPressed: () {
                      if (appStorage.getLanguageCode != AppConstants.arabic) {
                        appStorage.setLanguageCode = AppConstants.arabic;
                        context.read<LanguageCubit>().onLanguageChange(
                            languageCode: AppConstants.arabic);
                      }
                    },
                    child: const Text("Arabic"))
              ],
            ),
            const SizedBox(height: 30),
            _buildLoginTitleView(context),
            const SizedBox(height: 30),
            _buildMainView(context),
          ],
        ),
      ),
    );
  }

  _buildLoginTitleView(BuildContext context) {
    return kIsWeb ? _buildWebLoginTitleView() : _buildMobileLoginTitleView();
  }

  Container _buildMobileLoginTitleView() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          AppLocalizations.of(context)?.agreed ?? '',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
        ));
  }

  Widget _buildWebLoginTitleView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: AlignmentDirectional.center,
      child: RichText(
        text: TextSpan(
          text: "Sign Up",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.popUntil(
                  context, ModalRoute.withName(AppRoutes.initial));
            },
          children: const <TextSpan>[
            TextSpan(
                text: '  |  ',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black)),
            TextSpan(
                text: "Login",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryColor,
                    fontSize: 20)),
          ],
        ),
      ),
    );
  }

  _buildMainView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMobileNumberView(),
          const SizedBox(
            height: 15.0,
          ),
          _buildPasswordView(),
          _buildForgotPasswordView(context),
          const SizedBox(
            height: 30.0,
          ),
          SizedBox(
            child: StreamBuilder<bool>(
                stream: loginBloc.isSubmitCheck,
                builder: (_, submitSnapshot) {
                  return StreamBuilder<bool>(
                      stream: loginBloc.isLoading,
                      builder: (_, snapshot) {
                        return SolidRoundedElevatedButton(
                          isApiCalling: snapshot.data ?? false,
                          verticalPadding: kIsWeb ? 20.0 : 12.0,
                          title: "Login",
                          onPressed: () {
                            if (submitSnapshot.hasData) {
                              loginBloc.submit(context);
                            }
                          },
                        );
                      });
                }),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  void _onLoginPressed() {
    _formKey.currentState!.validate();
  }

  _buildForgotPasswordView(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomEnd,
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.filter);
          },
          child: const Text(
            "Forgot Password",
            style: TextStyle(color: Colors.grey),
          )),
    );
  }

  _buildPasswordView() {
    return StreamBuilder<String>(
        stream: loginBloc.passwordStream,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: loginBloc.isObscure,
              builder: (context, snapshot) {
                return PasswordWidget(
                  textEditingController: null,
                  initialValue: "" ,
                  hintText: "password",
                  isObscure: snapshot.data ?? false,
                  errorText:
                      snapshot.error != null ? snapshot.error.toString() : "",
                  validator: (newValue) {},
                  onPressedEye: () {
                    bool value = !snapshot.data!;
                    loginBloc.obscuredTapped(value);
                  },
                  onChanged: (String newValue) {
                    loginBloc.passChanged(newValue);
                  },
                  onFiledSubmitted: (newValue) {
                    _onLoginPressed();
                  },
                );
              });
        });
  }

  _buildMobileNumberView() {
    return StreamBuilder<String>(
        stream: loginBloc.mobileStream,
        builder: (context, snapshot) {
          return MobileNumberWidgets(
            textEditingController: null,
            initialValue: "",
              mobileNumberLength: 10,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : "",
              validator: (newValue) {},
              onChanged: (newValue) {
                loginBloc.mobChanged(newValue);
              });
        });
  }
}
