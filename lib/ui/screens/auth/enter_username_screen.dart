import 'package:Celes/app/app_routes.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';

class EnterUsernameScreen extends StatefulWidget {
  const EnterUsernameScreen({super.key});

  @override
  State<EnterUsernameScreen> createState() => _EnterUsernameScreenState();
}

class _EnterUsernameScreenState extends State<EnterUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  bool _isUsernameValid() {
    final username = _usernameController.text.trim();
    final latinRegex = RegExp(r'^[a-zA-Z]+$');
    return username.isNotEmpty && latinRegex.hasMatch(username);
  }

  void _onDone() {
    if (_isUsernameValid()) {
      final username = _usernameController.text.trim();
      print('Username: $username');
      Navigator.pop(context, username);
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
            const CustomText(
              'Enter Username',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFB800),
            ),
            const SizedBox(height: 8),
            const CustomText(
              'Latin characters, no emoji/symbols',
              fontSize: 16,
              color: Colors.white70,
            ),
            const SizedBox(height: 40),
            CustomTextField(
              controller: _usernameController,
              label: '',
              keyboardType: TextInputType.text,
              colorType: TextFieldColorType.transparent,
              height: 46,
              width: double.infinity,
              borderColor: Colors.transparent,
              borderRadius: 0,
              textColor: Colors.white,
              backgroundColor: Colors.transparent,
              inputFontSize: 24,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            Container(
              height: 1,
              color: Colors.white30,
              margin: const EdgeInsets.only(top: 8),
            ),
            const Spacer(),
            CustomButton(
              label: 'Done',
              onPressed: () {
                // if (_isUsernameValid()) {
                //   _onDone();
                // }
                Navigator.of(context).pushReplacementNamed(
                  Routes.main,
                  arguments: {
                    'from': "auth",
                  },
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
}
