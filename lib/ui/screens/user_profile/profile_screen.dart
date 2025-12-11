import 'dart:ui' as ui;

import 'package:Celes/app/app_theme.dart';
import 'package:Celes/data/cubits/system/app_theme_cubit.dart';
import 'package:Celes/ui/screens/main_activity.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/extensions/lib/translate.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  ValueNotifier isDarkTheme = ValueNotifier(false);
  ValueNotifier isFaceIDEnabled = ValueNotifier(false);
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isDarkTheme.value = context.read<AppThemeCubit>().isDarkMode();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isDarkTheme.dispose();
    isFaceIDEnabled.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(
          context: context, statusBarColor: context.color.primaryColor),
      child: Scaffold(
        backgroundColor: context.color.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: profileScreenController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header with title
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomText(
                    "Profile User",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: context.color.textColorDark,
                  ),
                ),

                // Profile Header Card
                _buildProfileHeader(),

                const SizedBox(height: 20),

                // Menu Items
                _buildMenuItems(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.color.secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.color.territoryColor.withOpacity(0.3),
                width: 2,
              ),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      "Angelina",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.color.textColorDark,
                    ),
                    const SizedBox(width: 8),
                    // Edit Icon
                    GestureDetector(
                      onTap: () {
                        // Handle edit profile
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: context.color.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: context.color.textColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: context.color.textColorDark.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      "(704) 555-0127",
                      fontSize: 13,
                      color: context.color.textColorDark.withOpacity(0.7),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: context.color.textColorDark.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      "angelina@example.com",
                      fontSize: 13,
                      color: context.color.textColorDark.withOpacity(0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItemWithSvg(
          iconPath: AppIcons.ticket_2,
          title: "My ticket",
          onTap: () {
            // Navigate to my tickets
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSvg(
          iconPath: AppIcons.shopping_cart,
          title: "Payment history",
          onTap: () {
            // Navigate to payment history
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSvg(
          iconPath: AppIcons.translate,
          title: "Change language",
          onTap: () {
            // Navigate to language settings
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSvg(
          iconPath: AppIcons.lock,
          title: "Change password",
          onTap: () {
            // Navigate to change password
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSwitchSvg(
          iconPath: AppIcons.Face_ID,
          title: "Face ID / Touch ID",
        ),
      ],
    );
  }

  Widget _buildMenuItemWithSvg({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.color.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.color.territoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      context.color.territoryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomText(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.color.textColorDark,
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.color.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: context.color.textColorDark,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemWithSwitchSvg({
    required String iconPath,
    required String title,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.color.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.color.territoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  context.color.territoryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.color.textColorDark,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: isFaceIDEnabled,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: value,
                    activeColor: const Color(0xFFFDB022), // Yellow/Gold color
                    onChanged: (newValue) {
                      isFaceIDEnabled.value = newValue;
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
