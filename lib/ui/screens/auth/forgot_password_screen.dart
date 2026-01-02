import 'package:Celes/data/cubits/auth/forgot_password_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/screens/auth/otp/forgot_password_otp_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/lib/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterEmail);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError(Tr.of(context)!.pleaseEnterValidEmail);
      return;
    }

    context.read<ForgotPasswordCubit>().sendResetLink(email: email);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ForgotPasswordOtpScreen(
                email: state.email,
              ),
            ),
          );
        } else if (state is ForgotPasswordFailure) {
          String errorMessage = state.errorMessage;

          if (state.errorCode == 'USER_NOT_FOUND') {
            errorMessage = Tr.of(context)!.userNotFound;
          } else if (state.errorCode == 'EMAIL_NOT_VERIFIED') {
            errorMessage = Tr.of(context)!.emailNotVerified;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordInProgress;

        return Scaffold(
          backgroundColor: context.color.primaryColor,
          appBar: AppBar(
            backgroundColor: context.color.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon:
                  Icon(Icons.arrow_back, color: context.color.textDefaultColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: CustomText(
              Tr.of(context)!.forgotPasswordTitle,
              color: context.color.textDefaultColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  CustomText(
                    Tr.of(context)!.resetYourPassword,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.color.textDefaultColor,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  CustomText(
                    Tr.of(context)!.resetPasswordDescription,
                    fontSize: 14,
                    color: context.color.descriptionColor,
                    maxLines: 3,
                    height: 1.5,
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

                  const SizedBox(height: 32),

                  // Send Reset Link Button
                  CustomButton(
                    label: isLoading
                        ? Tr.of(context)!.sending
                        : Tr.of(context)!.submit,
                    onPressed: isLoading ? () {} : _handleForgotPassword,
                    colorType: ButtonColorType.territory,
                    height: 56,
                    borderRadius: 10,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xFFF2F2F2),
                  ),

                  const SizedBox(height: 24),

                  // Back to Login
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: CustomText(
                        Tr.of(context)!.backToLogin,
                        fontSize: 16,
                        color: context.color.territoryColor,
                        showUnderline: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
