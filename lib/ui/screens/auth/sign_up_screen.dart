import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/screens/auth/otp/otp_confirm_screen.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // Validate fields
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showError('Please enter your password');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      _showError('Please enter your address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (response.success && response.data != null) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to OTP screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OtpConfirmScreen(
                email: response.data!.email,
              ),
            ),
          );
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        String errorMessage = e.message;

        // Handle specific error codes
        if (e.code == 'EMAIL_EXISTS') {
          errorMessage = 'This email is already registered';
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          'Sign up',
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Name Field
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                keyboardType: TextInputType.name,
                colorType: TextFieldColorType.dark,
                height: 56,
                borderColor: Colors.white,
                borderRadius: 12,
                textColor: Colors.white,
                backgroundColor: Colors.white,
                inputFontSize: 15,
              ),
              const SizedBox(height: 20),

              // Email Field
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                colorType: TextFieldColorType.dark,
                height: 56,
                borderColor: Colors.white,
                borderRadius: 12,
                textColor: Colors.white,
                backgroundColor: Colors.white,
                inputFontSize: 15,
              ),
              const SizedBox(height: 20),

              // Password Field
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                colorType: TextFieldColorType.dark,
                height: 56,
                borderColor: Colors.white,
                borderRadius: 12,
                textColor: Colors.white,
                backgroundColor: Colors.white,
                inputFontSize: 15,
              ),
              const SizedBox(height: 20),

              // Phone Field
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                colorType: TextFieldColorType.dark,
                height: 56,
                borderColor: Colors.white,
                borderRadius: 12,
                textColor: Colors.white,
                backgroundColor: Colors.white,
                inputFontSize: 15,
              ),
              const SizedBox(height: 20),

              // Address Field
              CustomTextField(
                controller: _addressController,
                label: 'Address',
                keyboardType: TextInputType.streetAddress,
                colorType: TextFieldColorType.dark,
                height: 56,
                borderColor: Colors.white,
                borderRadius: 12,
                textColor: Colors.white,
                backgroundColor: Colors.white,
                inputFontSize: 15,
              ),
              const SizedBox(height: 28),

              // Register Button
              CustomButton(
                label: _isLoading ? 'Creating account...' : 'Sign Up',
                onPressed: _isLoading ? () {} : _handleRegister,
                colorType: ButtonColorType.territory,
                height: 54,
                borderRadius: 27,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
              ),
              const SizedBox(height: 32),
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomText(
                      'Or continue with',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Facebook Button
              CustomButton(
                label: 'Facebook',
                onPressed: () {},
                styleType: ButtonStyleType.outlined,
                borderColor: Colors.grey.withOpacity(0.3),
                borderWidth: 1.0,
                textColor: Colors.white,
                height: 52,
                borderRadius: 26,
                leftWidget: SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: SvgPicture.asset(
                      AppIcons.facebook,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 14),

              // Google Button
              CustomButton(
                label: 'Google',
                onPressed: () {},
                styleType: ButtonStyleType.outlined,
                borderColor: Colors.grey.withOpacity(0.3),
                borderWidth: 1.0,
                textColor: Colors.white,
                height: 52,
                borderRadius: 26,
                leftWidget: SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: SvgPicture.asset(
                      AppIcons.google,
                      width: 26,
                      height: 26,
                    ),
                  ),
                ),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 32),
              // Terms and Privacy
              const CustomText(
                'By sign in or sign up, you agree to our Terms of Service\nand Privacy Policy',
                textAlign: TextAlign.center,
                color: Colors.grey,
                fontSize: 11,
                height: 1.4,
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
