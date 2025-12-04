import 'package:Celes/data/services/auth_service.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';

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
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation
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

    setState(() => _isLoading = true);

    try {
      final response = await _authService.resetPassword(
        email: widget.email,
        resetToken: widget.resetToken,
        password: password,
        passwordConfirmation: confirmPassword,
      );

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // Navigate back to login screen
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        String errorMessage = e.message;

        // Handle specific error codes
        if (e.code == 'INVALID_TOKEN') {
          errorMessage = 'Invalid or expired reset token';
        } else if (e.code == 'TOKEN_EXPIRED') {
          errorMessage = 'Reset token has expired. Please request a new one.';
        } else if (e.code == 'VALIDATION_ERROR' && e.errors != null) {
          // Get first validation error
          errorMessage = e.errors!.values.first.toString();
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
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          'Reset Password',
          color: Colors.white,
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
              const CustomText(
                'Create New Password',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB800),
              ),

              const SizedBox(height: 16),

              // Description
              CustomText(
                'Your new password must be different from previously used passwords.',
                fontSize: 14,
                color: Colors.white70,
                maxLines: 2,
                height: 1.5,
              ),

              const SizedBox(height: 8),

              // Email display
              CustomText(
                'Email: ${widget.email}',
                fontSize: 13,
                color: Colors.white60,
              ),

              const SizedBox(height: 40),

              // New Password Field
              CustomTextField(
                controller: _passwordController,
                label: 'New Password',
                hintText: '••••••',
                isPassword: true,
                colorType: TextFieldColorType.dark,
                height: 62,
                textColor: Colors.white,
                borderColor: Colors.white30,
              ),

              const SizedBox(height: 20),

              // Confirm Password Field
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hintText: '••••••',
                isPassword: true,
                colorType: TextFieldColorType.dark,
                height: 62,
                textColor: Colors.white,
                borderColor: Colors.white30,
              ),

              const SizedBox(height: 12),

              // Password requirements
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Password must:',
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                    SizedBox(height: 4),
                    CustomText(
                      '• Be at least 6 characters',
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                    CustomText(
                      '• Match the confirmation',
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Reset Password Button
              CustomButton(
                label: _isLoading ? 'Resetting...' : 'Reset Password',
                onPressed: _isLoading ? () {} : _handleResetPassword,
                colorType: ButtonColorType.territory,
                height: 56,
                borderRadius: 10,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
              ),

              const SizedBox(height: 24),

              // Back to Login
              Center(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const CustomText(
                    'Back to Login',
                    fontSize: 16,
                    color: Color(0xFFFFB800),
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
  }
}
