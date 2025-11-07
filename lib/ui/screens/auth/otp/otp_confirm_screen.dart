import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/screens/auth/enter_username_screen.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpConfirmScreen extends StatefulWidget {
  // final String phoneNumber;

  const OtpConfirmScreen({
    super.key,
    // required this.phoneNumber,
  });

  @override
  State<OtpConfirmScreen> createState() => _OtpConfirmScreenState();
}

class _OtpConfirmScreenState extends State<OtpConfirmScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late AnimationController _timerController;
  late Animation<int> _timerAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize timer animation (60 seconds countdown)
    _timerController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );

    _timerAnimation = IntTween(begin: 59, end: 0).animate(_timerController);

    // Start countdown
    _timerController.forward();

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timerController.dispose();
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field if not the last one
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // If last field, unfocus
        _focusNodes[index].unfocus();
      }
    } else {
      // Move to previous field if not the first one
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  bool _isOtpComplete() {
    return _getOtpCode().length == 6;
  }

  void _onContinue() {
    if (_isOtpComplete()) {
      final otpCode = _getOtpCode();
      print('OTP Code: $otpCode');
      // Handle OTP verification
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            const CustomText(
              'Confirm OTP code',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFB800), // Orange/yellow color
            ),

            const SizedBox(height: 16),

            // Description
            CustomText(
              // 'You just need to enter the OTP sent to the registered phone number ${widget.phoneNumber}.',
              'You just need to enter the OTP sent to the registered phone number 00000000000',
              fontSize: 13,
              color: Colors.white70,
              maxLines: 2,
            ),

            const SizedBox(height: 40),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpField(index)),
            ),

            const SizedBox(height: 24),

            // Timer
            AnimatedBuilder(
              animation: _timerAnimation,
              builder: (context, child) {
                final minutes = _timerAnimation.value ~/ 60;
                final seconds = _timerAnimation.value % 60;
                return Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),

            const Spacer(),

            // Continue Button
            CustomButton(
              label: 'Continue',
              onPressed: () {
                // if (_isOtpComplete()) {
                //   _onContinue();
                // }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const EnterUsernameScreen()),
                );
              },
              colorType: ButtonColorType.territory,
              height: 56,
              borderRadius: 28,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _controllers[index].text.isNotEmpty
              ? const Color(0xFFFFB800)
              : Colors.grey.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Center(
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            setState(() {
              _onDigitChanged(value, index);
            });
          },
        ),
      ),
    );
  }
}
