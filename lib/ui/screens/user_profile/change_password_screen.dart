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
      _showError('Please enter your current password');
      return;
    }

    if (newPassword.isEmpty) {
      _showError('Please enter your new password');
      return;
    }

    if (newPassword.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('New password and confirmation do not match');
      return;
    }

    if (currentPassword == newPassword) {
      _showError('New password must be different from current password');
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
          errorMessage = 'Current password is incorrect';
        } else if (e.code == 'UNAUTHORIZED') {
          errorMessage = 'Please login to change password';
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
      return 'This field is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
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
                  'Enter your current password and choose a new password.',
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
                  hintText: 'Enter your current password',
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  colorType: TextFieldColorType.dark,
                  height: 62,
                  textColor: context.color.textColorDark,
                  borderColor:
                      context.color.textColorDark.withValues(alpha: 0.3),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // New Password Field
                CustomTextField(
                  controller: _newPasswordController,
                  label: Tr.of(context)!.newPassword,
                  hintText: 'Enter your new password',
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
                  hintText: 'Confirm your new password',
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
