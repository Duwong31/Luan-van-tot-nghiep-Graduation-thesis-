import 'package:Celes/app/app_theme.dart';
import 'package:Celes/app/app_routes.dart';
import 'package:Celes/data/cubits/auth/profile_cubit.dart';
import 'package:Celes/data/cubits/system/app_theme_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/screens/language/language_selection_screen.dart';
import 'package:Celes/ui/screens/main_activity.dart';
import 'package:Celes/ui/screens/user_profile/change_password_screen.dart';
import 'package:Celes/ui/screens/user_profile/edit_profile_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/helper_utils.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:Celes/data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    _loadProfile();
  }

  void _loadProfile() {
    final profileCubit = context.read<ProfileCubit>();
    profileCubit.loadUserFromCache();
    profileCubit.fetchProfile();
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

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          // Navigate to login screen and clear navigation stack
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.signIn,
            (route) => false,
          );
        } else if (state is LogoutError) {
          HelperUtils.showSnackBarMessage(context, state.errorMessage);
        }
      },
      child: AnnotatedRegion(
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
                      Tr.of(context)!.profile,
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
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        User? user;
        if (state is ProfileLoaded) {
          user = state.user;
        } else if (state is LogoutLoading) {
          user = state.user;
        } else if (state is LogoutError) {
          user = state.user;
        }

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
                    color: context.color.territoryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: user?.avatarUrl != null
                      ? CachedNetworkImage(
                          imageUrl: user!.avatarUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.color.territoryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            debugPrint("Error loading image: $url - $error");
                            return Icon(
                              Icons.person,
                              size: 40,
                              color: context.color.textColorDark,
                            );
                          },
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                          color: context.color.textColorDark,
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
                        Flexible(
                          child: state is ProfileLoading
                              ? Container(
                                  height: 20,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: context.color.backgroundColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                              : CustomText(
                                  user?.name ?? Tr.of(context)!.guest,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: context.color.textColorDark,
                                  maxLines: 1,
                                ),
                        ),
                        const SizedBox(width: 8),
                        // Edit Icon
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                            // Reload profile if updated successfully
                            if (result == true) {
                              context.read<ProfileCubit>().refreshProfile();
                            }
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
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: context.color.textColorDark
                              .withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          user?.phone ?? Tr.of(context)!.noPhoneNumber,
                          fontSize: 13,
                          color: context.color.textColorDark
                              .withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: context.color.textColorDark
                              .withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          user?.email ?? Tr.of(context)!.noEmail,
                          fontSize: 13,
                          color: context.color.textColorDark
                              .withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItemWithSvg(
          iconPath: AppIcons.ticket_2,
          title: Tr.of(context)!.myTicket,
          onTap: () {
            // Navigate to my tickets
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSvg(
          iconPath: AppIcons.shopping_cart,
          title: Tr.of(context)!.paymentHistory,
          onTap: () {
            // Navigate to payment history
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSvg(
          iconPath: AppIcons.translate,
          title: Tr.of(context)!.changeLanguage,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LanguageSelectionScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildThemeSwitchItem(
          iconPath: AppIcons.darkTheme,
          title: Tr.of(context)!.darkTheme,
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSvg(
          iconPath: AppIcons.lock,
          title: Tr.of(context)!.changePassword,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemWithSwitchSvg(
          iconPath: AppIcons.Face_ID,
          title: Tr.of(context)!.faceIdTouchId,
        ),
        const SizedBox(height: 12),
        _buildLogoutButton(),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.color.secondaryColor,
        title: CustomText(
          Tr.of(context)!.logoutConfirmTitle,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: context.color.textColorDark,
        ),
        content: CustomText(
          Tr.of(context)!.logoutConfirmMessage,
          fontSize: 16,
          color: context.color.textColorDark,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: CustomText(
              Tr.of(context)!.cancel,
              fontSize: 16,
              color: context.color.textColorDark,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
              // Trigger logout
              context.read<ProfileCubit>().logout();
            },
            child: CustomText(
              Tr.of(context)!.logout,
              fontSize: 16,
              color: context.color.territoryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final bool isLoggingOut = state is LogoutLoading;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: context.color.secondaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoggingOut ? null : _showLogoutDialog,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isLoggingOut
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomText(
                        isLoggingOut
                            ? Tr.of(context)!.loggingOut
                            : Tr.of(context)!.logout,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
                    color: context.color.territoryColor.withValues(alpha: 0.1),
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
                color: context.color.territoryColor.withValues(alpha: 0.1),
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
                    activeTrackColor:
                        const Color(0xFFFDB022), // Yellow/Gold color
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

  Widget _buildThemeSwitchItem({
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
                color: context.color.territoryColor.withValues(alpha: 0.1),
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
              valueListenable: isDarkTheme,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: value,
                    activeTrackColor: context.color.territoryColor,
                    onChanged: (newValue) {
                      final newTheme =
                          newValue ? AppTheme.dark : AppTheme.light;
                      this.context.read<AppThemeCubit>().changeTheme(newTheme);
                      isDarkTheme.value = newValue;
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
