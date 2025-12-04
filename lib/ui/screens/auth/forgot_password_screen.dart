import 'package:Celes/data/services/auth_service.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/screens/auth/otp/forgot_password_otp_screen.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter your email');
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.forgotPassword(email: email);

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate to OTP verification screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ForgotPasswordOtpScreen(
                email: email,
              ),
            ),
          );
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        String errorMessage = e.message;

        // Handle specific error codes
        if (e.code == 'USER_NOT_FOUND') {
          errorMessage = 'No account found with this email';
        } else if (e.code == 'EMAIL_NOT_VERIFIED') {
          errorMessage = 'Please verify your email first';
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
          'Forgot Password',
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
                'Reset Your Password',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB800),
              ),

              const SizedBox(height: 16),

              // Description
              const CustomText(
                'Enter your email address and we will send you instructions to reset your password.',
                fontSize: 14,
                color: Colors.white70,
                maxLines: 3,
                height: 1.5,
              ),

              const SizedBox(height: 40),

              // Email Field
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
                colorType: TextFieldColorType.dark,
                height: 62,
                textColor: Colors.white,
                borderColor: Colors.white30,
              ),

              const SizedBox(height: 32),

              // Send Reset Link Button
              CustomButton(
                label: _isLoading ? 'Sending...' : 'Submit',
                onPressed: _isLoading ? () {} : _handleForgotPassword,
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
                  onTap: () => Navigator.of(context).pop(),
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
