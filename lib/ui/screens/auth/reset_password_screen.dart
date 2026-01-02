import 'package:Celes/app/app_routes.dart';
import 'package:Celes/data/cubits/auth/reset_password_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/lib/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String resetToken;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty) {
      _showError('Please enter your new password');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showError('Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    context.read<ResetPasswordCubit>().resetPassword(
          email: widget.email,
          resetToken: widget.resetToken,
          password: password,
          passwordConfirmation: confirmPassword,
        );
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
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.signIn,
            (route) => false,
          );
        } else if (state is ResetPasswordFailure) {
          String errorMessage = state.errorMessage;

          if (state.errorCode == 'INVALID_TOKEN') {
            errorMessage = 'Invalid or expired reset token';
          } else if (state.errorCode == 'TOKEN_EXPIRED') {
            errorMessage = 'Reset token has expired. Please request a new one.';
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
        final isLoading = state is ResetPasswordInProgress;

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
              Tr.of(context)!.resetPassword,
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
                    Tr.of(context)!.createNewPassword,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.color.textDefaultColor,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  CustomText(
                    Tr.of(context)!.createNewPasswordDescription,
                    fontSize: 14,
                    color: context.color.descriptionColor,
                    maxLines: 2,
                    height: 1.5,
                  ),

                  const SizedBox(height: 8),

                  // Email display
                  CustomText(
                    'Email: ${widget.email}',
                    fontSize: 13,
                    color: context.color.descriptionColor,
                  ),

                  const SizedBox(height: 40),

                  // New Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: Tr.of(context)!.newPassword,
                    hintText: '••••••',
                    isPassword: true,
                    colorType: TextFieldColorType.dark,
                    height: 62,
                    textColor: context.color.textDefaultColor,
                    borderColor:
                        context.color.borderColor.withValues(alpha: 0.3),
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password Field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: Tr.of(context)!.confirmNewPassword,
                    hintText: '••••••',
                    isPassword: true,
                    colorType: TextFieldColorType.dark,
                    height: 62,
                    textColor: context.color.textDefaultColor,
                    borderColor:
                        context.color.borderColor.withValues(alpha: 0.3),
                  ),

                  const SizedBox(height: 12),

                  // Password requirements
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Password must:',
                          fontSize: 12,
                          color: context.color.descriptionColor,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          '• Be at least 6 characters',
                          fontSize: 12,
                          color: context.color.descriptionColor,
                        ),
                        CustomText(
                          '• Match the confirmation',
                          fontSize: 12,
                          color: context.color.descriptionColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Reset Password Button
                  CustomButton(
                    label: isLoading
                        ? Tr.of(context)!.resettingPassword
                        : Tr.of(context)!.resetPassword,
                    onPressed: isLoading ? () {} : _handleResetPassword,
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
                      onTap: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
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
