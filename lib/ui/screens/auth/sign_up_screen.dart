import 'package:Celes/data/cubits/auth/register_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/screens/auth/otp/otp_confirm_screen.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_nameController.text.trim().isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterName);
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterEmail);
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterPassword);
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterPhone);
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      _showError(Tr.of(context)!.pleaseEnterAddress);
      return;
    }

    context.read<RegisterCubit>().register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
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
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OtpConfirmScreen(
                email: state.user.email,
              ),
            ),
          );
        } else if (state is RegisterFailure) {
          String errorMessage = state.errorMessage;

          if (state.errorCode == 'EMAIL_EXISTS') {
            errorMessage = Tr.of(context)!.emailAlreadyRegistered;
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
        final isLoading = state is RegisterInProgress;

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
            title: CustomText(
              Tr.of(context)!.signUpTitle,
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
                    label: Tr.of(context)!.fullName,
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
                    label: Tr.of(context)!.email,
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
                    label: Tr.of(context)!.password,
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
                    label: Tr.of(context)!.phoneNumber,
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
                    label: Tr.of(context)!.address,
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
                    label: isLoading
                        ? Tr.of(context)!.creatingAccount
                        : Tr.of(context)!.signUp,
                    onPressed: isLoading ? () {} : _handleRegister,
                    colorType: ButtonColorType.territory,
                    height: 54,
                    borderRadius: 27,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.white,
                  ),
                  // const SizedBox(height: 32),
                  // // Divider
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         height: 1,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     const Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 16.0),
                  //       child: CustomText(
                  //         'Or continue with',
                  //         color: Colors.white,
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         height: 1,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 18),

                  // // Facebook Button
                  // CustomButton(
                  //   label: 'Facebook',
                  //   onPressed: () {},
                  //   styleType: ButtonStyleType.outlined,
                  //   borderColor: Colors.grey.withValues(alpha: 0.3),
                  //   borderWidth: 1.0,
                  //   textColor: Colors.white,
                  //   height: 52,
                  //   borderRadius: 26,
                  //   leftWidget: SizedBox(
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
                  //   fontSize: 15,
                  //   fontWeight: FontWeight.w500,
                  // ),
                  // const SizedBox(height: 14),

                  // // Google Button
                  // CustomButton(
                  //   label: 'Google',
                  //   onPressed: () {},
                  //   styleType: ButtonStyleType.outlined,
                  //   borderColor: Colors.grey.withValues(alpha: 0.3),
                  //   borderWidth: 1.0,
                  //   textColor: Colors.white,
                  //   height: 52,
                  //   borderRadius: 26,
                  //   leftWidget: SizedBox(
                  //     width: 20,
                  //     height: 20,
                  //     child: Center(
                  //       child: SvgPicture.asset(
                  //         AppIcons.google,
                  //         width: 26,
                  //         height: 26,
                  //       ),
                  //     ),
                  //   ),
                  //   fontSize: 15,
                  //   fontWeight: FontWeight.w500,
                  // ),
                  const SizedBox(height: 32),
                  // Terms and Privacy
                  CustomText(
                    Tr.of(context)!.termsAndPrivacy,
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
      },
    );
  }
}
