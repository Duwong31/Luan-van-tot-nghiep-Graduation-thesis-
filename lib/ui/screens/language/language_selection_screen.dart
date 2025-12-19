import 'package:Celes/data/cubits/system/language_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(
          context: context, statusBarColor: context.color.primaryColor),
      child: Scaffold(
        backgroundColor: context.color.primaryColor,
        appBar: AppBar(
          backgroundColor: context.color.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.color.textColorDark,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: CustomText(
            Tr.of(context)!.selectLanguage,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: context.color.textColorDark,
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              String currentLanguage = 'vi';
              if (state is LanguageLoaded) {
                currentLanguage = state.locale.languageCode;
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildLanguageOption(
                      languageCode: 'vi',
                      languageName: Tr.of(context)!.vietnamese,
                      flag: '🇻🇳',
                      isSelected: currentLanguage == 'vi',
                      onTap: () {
                        context.read<LanguageCubit>().changeLanguage(const Locale('vi'));
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLanguageOption(
                      languageCode: 'en',
                      languageName: Tr.of(context)!.english,
                      flag: '🇬🇧',
                      isSelected: currentLanguage == 'en',
                      onTap: () {
                        context.read<LanguageCubit>().changeLanguage(const Locale('en'));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? context.color.territoryColor
              : context.color.textColorDark.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Text(
                  flag,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomText(
                    languageName,
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: context.color.textColorDark,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: context.color.territoryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

