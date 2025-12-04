import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_svg/svg.dart';

enum TextFieldColorType { light, dark, transparent, custom }

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool isRequired;
  final bool isPassword;
  final bool isPhoneField;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // Add validator

  final TextFieldColorType? colorType;

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;

  final double? hintFontSize;
  final double? inputFontSize;
  final Color? textColor;
  final String? imgSvg;

  final String? countryCode;
  final String? flagEmoji;
  final ValueChanged<String>? onCountryCodeChanged;
  final ValueChanged<Country>? onCountrySelected;
  final bool obscureInitially;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.isRequired = false,
    this.isPassword = false,
    this.isPhoneField = false,
    this.keyboardType = TextInputType.text,
    this.validator, // Add validator
    this.colorType,
    this.width,
    this.height = 64, // Default height
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.hintFontSize,
    this.inputFontSize,
    this.textColor,
    this.imgSvg,
    this.countryCode,
    this.flagEmoji,
    this.onCountryCodeChanged,
    this.onCountrySelected,
    this.obscureInitially = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure = false;

  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword && widget.obscureInitially;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(context);

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 64,
      child: Container(
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          border: Border.all(
            color: widget.borderColor ??
                context.color.textLightColor.withValues(alpha: 0.3),
            width: widget.borderWidth ?? 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 2),
            Row(
              children: [
                if (widget.imgSvg != null) ...[
                  SvgPicture.asset(
                    widget.imgSvg!,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(widget.textColor ??
                        context.color.textColorDark.withValues(alpha: 0.6), BlendMode.srcIn),
                  ),
                  const SizedBox(width: 4),
                ],
                CustomText(
                  widget.label,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: widget.textColor ??
                      context.color.textColorDark.withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: widget.isPhoneField
                  ? _buildPhoneField(context)
                  : _buildNormalField(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalField(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator, // Add validator
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText ?? "",
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: (widget.textColor ?? context.color.textColorDark)
              .withValues(alpha: 0.5),
        ),
        contentPadding: const EdgeInsets.only(top: 6),
        isDense: true,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => obscure = !obscure),
                icon: SvgPicture.asset(
                  obscure ? AppIcons.eyes_close : AppIcons.eyes,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(context.color.textColorDark.withValues(alpha: 0.3), BlendMode.srcIn),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            : null,
      ),
      style: TextStyle(
        fontSize: widget.inputFontSize ?? context.font.large,
        color: widget.textColor ?? context.color.textColorDark,
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showCountryPicker(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.flagEmoji != null)
                Text(widget.flagEmoji ?? '',
                    style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                "+${widget.countryCode ?? '84'}",
                style: TextStyle(
                  fontSize: widget.inputFontSize ?? 16,
                  fontWeight: FontWeight.w400,
                  color: widget.textColor ?? context.color.textColorDark,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            validator: widget.validator, // Add validator
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText ?? "",
              hintStyle: TextStyle(
                fontSize: widget.hintFontSize ?? 16,
                color: context.color.textColorDark.withValues(alpha: 0.5),
              ),
              contentPadding: const EdgeInsets.only(top: 1),
              isDense: true,
            ),
            style: TextStyle(
              fontSize: widget.inputFontSize ?? 16,
              color: widget.textColor ?? context.color.textColorDark,
            ),
          ),
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showWorldWide: false,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(12),
        flagSize: 24,
        textStyle: const TextStyle(fontSize: 16),
      ),
      onSelect: (Country country) {
        widget.onCountryCodeChanged?.call(country.phoneCode);
        widget.onCountrySelected?.call(country);
      },
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.colorType) {
      case TextFieldColorType.light:
        return context.color.secondaryColor;
      case TextFieldColorType.dark:
        return context.color.primaryColor.withValues(alpha: 0.1);
      case TextFieldColorType.transparent:
        return Colors.transparent;
      case TextFieldColorType.custom:
        return widget.backgroundColor ?? context.color.secondaryColor;
      default:
        return context.color.secondaryColor;
    }
  }
}
