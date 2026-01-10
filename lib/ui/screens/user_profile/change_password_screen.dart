import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterCurrentPassword);
      return;
    }

    if (newPassword.isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterNewPassword);
      return;
    }

    if (newPassword.length < 6) {
      _showError(Tr.of(context)!.passwordMinLength);
      return;
    }

    if (newPassword != confirmPassword) {
      _showError(Tr.of(context)!.passwordsDoNotMatch);
      return;
    }

    if (currentPassword == newPassword) {
      _showError(Tr.of(context)!.newPasswordMustBeDifferent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.changePassword(
        currentPassword: currentPassword,
        password: newPassword,
        passwordConfirmation: confirmPassword,
      );

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate back after successful password change
          Navigator.of(context).pop();
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        String errorMessage = e.message;

        // Handle specific error codes
        if (e.code == 'INVALID_PASSWORD' || e.code == 'WRONG_PASSWORD') {
          errorMessage = Tr.of(context)!.currentPasswordIncorrect;
        } else if (e.code == 'UNAUTHORIZED') {
          errorMessage = Tr.of(context)!.pleaseLoginToChangePassword;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Tr.of(context)!.anErrorOccurred),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Tr.of(context)!.fieldRequired;
    }
    if (value.length < 6) {
      return Tr.of(context)!.passwordMinLength;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return Tr.of(context)!.pleaseConfirmPassword;
    }
    if (value != _newPasswordController.text) {
      return Tr.of(context)!.passwordMismatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.color.textColorDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          Tr.of(context)!.changePassword,
          color: context.color.textColorDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Title
                CustomText(
                  Tr.of(context)!.changePasswordTitle,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: context.color.territoryColor,
                ),

                const SizedBox(height: 16),

                // Description
                CustomText(
                  Tr.of(context)!.changePasswordDescription,
                  fontSize: 14,
                  color: context.color.textColorDark.withValues(alpha: 0.7),
                  maxLines: 3,
                  height: 1.5,
                ),

                const SizedBox(height: 40),

                // Current Password Field
                CustomTextField(
                  controller: _currentPasswordController,
                  label: Tr.of(context)!.currentPassword,
                  hintText: Tr.of(context)!.enterCurrentPassword,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  colorType: TextFieldColorType.dark,
                  height: 62,
                  textColor: context.color.textColorDark,
                  borderColor:
                      context.color.textColorDark.withValues(alpha: 0.3),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Tr.of(context)!.pleaseEnterCurrentPassword;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // New Password Field
                CustomTextField(
                  controller: _newPasswordController,
                  label: Tr.of(context)!.newPassword,
                  hintText: Tr.of(context)!.enterNewPassword,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  colorType: TextFieldColorType.dark,
                  height: 62,
                  textColor: context.color.textColorDark,
                  borderColor:
                      context.color.textColorDark.withValues(alpha: 0.3),
                  validator: _validatePassword,
                ),

                const SizedBox(height: 24),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: Tr.of(context)!.confirmNewPassword,
                  hintText: Tr.of(context)!.confirmNewPasswordHint,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  colorType: TextFieldColorType.dark,
                  height: 62,
                  textColor: context.color.textColorDark,
                  borderColor:
                      context.color.textColorDark.withValues(alpha: 0.3),
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 32),

                // Change Password Button
                CustomButton(
                  label: _isLoading
                      ? Tr.of(context)!.savingPassword
                      : Tr.of(context)!.savePassword,
                  onPressed: _isLoading ? () {} : _handleChangePassword,
                  colorType: ButtonColorType.territory,
                  height: 56,
                  borderRadius: 10,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
