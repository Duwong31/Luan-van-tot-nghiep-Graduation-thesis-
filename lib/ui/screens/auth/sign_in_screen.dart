import 'package:Celes/app/app_routes.dart';
import 'package:Celes/data/cubits/auth/login_cubit.dart';
import 'package:Celes/data/cubits/system/notification_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/lib/build_context.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  final bool? isDeleteAccount;
  final bool? popToCurrent;
  final String? email;

  const LoginScreen({
    super.key,
    this.isDeleteAccount,
    this.popToCurrent,
    this.email,
  });

  @override
  State<LoginScreen> createState() => LoginScreenState();

  static MaterialPageRoute route(RouteSettings routeSettings) {
    Map? args = routeSettings.arguments as Map?;
    return MaterialPageRoute(
      builder: (_) => LoginScreen(
        isDeleteAccount: args?['isDeleteAccount'],
        popToCurrent: args?['popToCurrent'],
        email: args?['email'] as String?,
      ),
    );
  }
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterEmail);
      return;
    }

    if (password.isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterPassword);
      return;
    }

    // Gọi LoginCubit để xử lý login
    context.read<LoginCubit>().login(
          email: email,
          password: password,
        );
  }

  // void _onFacebookLogin() {
  //   // Handle Facebook login
  //   print('Facebook login pressed');
  //   _showSnackBar('Facebook login not implemented');
  // }

  // void _onGoogleLogin() {
  //   // Handle Google login
  //   print('Google login pressed');
  //   _showSnackBar('Google login not implemented');
  // }

  void _onSignUp() {
    Navigator.of(context).pushNamed(Routes.signUp);
  }

  void _onForgotPassword() {
    Navigator.of(context).pushNamed(Routes.forgotPassword);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _sendFcmTokenToServer() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null && mounted) {
      print('FCM Token: $fcmToken');
      context.read<NotificationCubit>().sendFcmToken(fcmToken);
    }
    // Subscribe to topic
    await FirebaseMessaging.instance.subscribeToTopic('celes_all_users');
  }

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              final userData = state.data['user'] as Map<String, dynamic>?;
              print('✅ Login successful');
              print('User: ${userData?['name']}');

              _sendFcmTokenToServer();

              // Navigate to main screen
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.main,
                (route) => false,
                arguments: {
                  'from': 'login',
                  'slug': null,
                },
              );
            } else if (state is LoginFailure) {
              String errorMessage = state.errorMessage;

              // Handle specific error codes
              if (state.errorCode == 'INVALID_CREDENTIALS') {
                errorMessage = Tr.of(context)!.invalidCredentials;
              } else if (state.errorCode == 'ACCOUNT_NOT_VERIFIED') {
                errorMessage = Tr.of(context)!.accountNotVerified;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final isLoading = state is LoginInProgress;

          return Scaffold(
            backgroundColor: context.color.primaryColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Close button (top right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close,
                            color: context.color.textDefaultColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Title and subtitle
                    Center(
                      child: Column(
                        children: [
                          CustomText(
                            Tr.of(context)!.logInTitle,
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: context.color.textDefaultColor,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            Tr.of(context)!.logInSubtitle,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: context.color.descriptionColor,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      label: Tr.of(context)!.email,
                      hintText: 'example@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      colorType: TextFieldColorType.dark,
                      height: 62,
                      textColor: context.color.textDefaultColor,
                      borderColor:
                          context.color.borderColor.withValues(alpha: 0.3),
                    ),

                    const SizedBox(height: 25),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      label: Tr.of(context)!.password,
                      hintText: '••••••',
                      isPassword: true,
                      colorType: TextFieldColorType.dark,
                      height: 62,
                      textColor: context.color.textDefaultColor,
                      borderColor:
                          context.color.borderColor.withValues(alpha: 0.3),
                    ),

                    const SizedBox(height: 10),

                    // Remember Me and Forgot Password
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) =>
                                setState(() => _rememberMe = value ?? false),
                            activeColor: context.color.territoryColor,
                            checkColor: context.color.primaryColor,
                            side: BorderSide(
                              color: context.color.borderColor,
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          Tr.of(context)!.rememberMe,
                          color: context.color.textDefaultColor,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: _onForgotPassword,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: CustomText(
                            Tr.of(context)!.forgotPassword,
                            color: context.color.territoryColor,
                            fontSize: 16,
                            showUnderline: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Login Button with Biometric
                    Row(
                      children: [
                        // Login Button
                        Expanded(
                          child: CustomButton(
                            label: isLoading
                                ? Tr.of(context)!.loggingIn
                                : Tr.of(context)!.logIn,
                            onPressed: isLoading ? () {} : _onLogin,
                            colorType: ButtonColorType.territory,
                            height: 56,
                            borderRadius: 10,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: const Color(0xFFF2F2F2),
                          ),
                        ),

                        // const SizedBox(width: 12),

                        // Biometric Fingerprint Button
                        // Container(
                        //   height: 56,
                        //   width: 56,
                        //   decoration: BoxDecoration(
                        //     color: context.color.forthColor,
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(
                        //       color: context.color.borderColor
                        //           .withValues(alpha: 0.3),
                        //       width: 1,
                        //     ),
                        //   ),
                        //   child: IconButton(
                        //     onPressed: () {},
                        //     icon: SvgPicture.asset(
                        //       AppIcons.biometricFingerprint,
                        //       width: 32,
                        //       height: 32,
                        //       colorFilter: ColorFilter.mode(
                        //         context.color.textDefaultColor,
                        //         BlendMode.srcIn,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    // const SizedBox(height: 30),

                    // // Or Divider
                    // const Row(
                    //   children: [
                    //     Expanded(child: Divider(color: Colors.white30)),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 16.0),
                    //       child: CustomText(
                    //         'Or',
                    //         color: Colors.white70,
                    //         fontSize: 16,
                    //       ),
                    //     ),
                    //     Expanded(child: Divider(color: Colors.white30)),
                    //   ],
                    // ),

                    // const SizedBox(height: 22),

                    // // Social Login Buttons
                    // CustomButton(
                    //   label: 'Facebook',
                    //   onPressed: _onFacebookLogin,
                    //   styleType: ButtonStyleType.outlined,
                    //   borderColor: Colors.grey.withValues(alpha: 0.3),
                    //   borderWidth: 1.0,
                    //   textColor: Colors.white,
                    //   height: 56,
                    //   borderRadius: 10,
                    //   leftWidget: Container(
                    //     width: 20,
                    //     height: 20,
                    //     child: Center(
                    //       child: SvgPicture.asset(
                    //         AppIcons.facebook,
                    //         width: 20,
                    //         height: 20,
                    //       ),
                    //     ),
                    //   ),
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.w500,
                    // ),

                    // const SizedBox(height: 16),

                    // CustomButton(
                    //   label: 'Google',
                    //   onPressed: _onGoogleLogin,
                    //   styleType: ButtonStyleType.outlined,
                    //   borderColor: Colors.grey.withValues(alpha: 0.3),
                    //   borderWidth: 1.0,
                    //   textColor: Colors.white,
                    //   height: 56,
                    //   borderRadius: 10,
                    //   leftWidget: Container(
                    //     width: 20,
                    //     height: 20,
                    //     child: Center(
                    //       child: SvgPicture.asset(
                    //         AppIcons.google,
                    //         width: 20,
                    //         height: 20,
                    //       ),
                    //     ),
                    //   ),
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.w500,
                    // ),

                    const SizedBox(height: 24),

                    // Sign Up Link
                    Center(
                      child: Column(
                        children: [
                          CustomText(
                            Tr.of(context)!.haveNotAccount,
                            fontSize: 16,
                            color: context.color.descriptionColor,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _onSignUp,
                            child: CustomText(
                              Tr.of(context)!.signUpNow,
                              fontSize: 16,
                              color: context.color.territoryColor,
                              showUnderline: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
