import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/screens/auth/otp/otp_confirm_screen.dart'
    show OtpConfirmScreen;
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? countryCode = '84';
  String? flagEmoji = '🇻🇳';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
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
            child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                CustomTextField(
                  controller: _phoneController,
                  label: '',
                  isPhoneField: true,
                  colorType: TextFieldColorType.dark,
                  height: 60,
                  countryCode: countryCode,
                  flagEmoji: flagEmoji,
                  borderColor: Colors.white,
                  borderRadius: 12,
                  textColor: Colors.white,
                  backgroundColor: Colors.white,
                  inputFontSize: 18,
                  onCountryCodeChanged: (code) {
                    setState(() {
                      countryCode = code;
                    });
                  },
                  onCountrySelected: (country) {
                    setState(() {
                      countryCode = country.phoneCode;
                      flagEmoji = country.flagEmoji;
                    });
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Continue',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const OtpConfirmScreen()),
                    );
                  },
                  colorType: ButtonColorType.territory,
                  height: 56,
                  borderRadius: 28,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                ),
                const Spacer(),
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
                        fontSize: 14,
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
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Facebook',
                  onPressed: () {},
                  styleType: ButtonStyleType.outlined,
                  borderColor: Colors.grey.withValues(alpha: 0.3),
                  borderWidth: 1.0,
                  textColor: Colors.white,
                  height: 56,
                  borderRadius: 28,
                  leftWidget: Container(
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
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Google',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const OtpConfirmScreen()),
                    );
                  },
                  styleType: ButtonStyleType.outlined,
                  borderColor: Colors.grey.withValues(alpha: 0.3),
                  borderWidth: 1.0,
                  textColor: Colors.white,
                  height: 56,
                  borderRadius: 28,
                  leftWidget: Container(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.google,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 40),
                const CustomText(
                  'By sign in or sign up, you agree to our Terms of Service\nand Privacy Policy',
                  textAlign: TextAlign.center,
                  color: Colors.grey,
                  fontSize: 12,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        )));
  }
}
