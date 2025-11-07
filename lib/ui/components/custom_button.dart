import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';

enum ButtonColorType { primary, territory, textDefault }

enum ButtonStyleType { filled, outlined } // Đã thêm

enum RightIconType { arrow, checkbox }

enum ButtonContentAlignment { left, center }

enum IconPosition { left, right }

class CustomButton extends StatelessWidget {
  final String? label;
  final IconData? leftIcon;
  final String? imgSvg;
  final Widget? leftWidget;
  final RightIconType? rightIconType;
  final VoidCallback onPressed;
  final bool useFittedBox;

  final ButtonColorType? colorType;
  final ButtonStyleType? styleType;
  final Color? textColor;
  final Color? labelColor;
  final ButtonContentAlignment? contentAlignment;

  final double? width;
  final double? height;

  final bool? isChecked;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final bool? useOriginalSvgColor;
  final IconPosition? iconPosition;
  final Color? borderColor;
  final double? borderWidth;

  const CustomButton({
    super.key,
    this.label,
    required this.onPressed,
    this.leftIcon,
    this.imgSvg,
    this.leftWidget,
    this.rightIconType,
    this.isChecked,
    this.colorType,
    this.styleType,
    this.textColor,
    this.labelColor,
    this.contentAlignment,
    this.width,
    this.height = 48, // Default height
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.useOriginalSvgColor = false,
    this.useFittedBox = false,
    this.iconPosition = IconPosition.left,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _getBackgroundColor(context);
    final Color txtColor = textColor ?? _getTextColor(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            side: _getBorderSide(context),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Align(
          alignment: _getMainAxisAlignmentAlign(),
          child: Row(
            mainAxisAlignment: _getMainAxisAlignment(),
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leftWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: leftWidget!,
                )
              else if (leftIcon != null || imgSvg != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: imgSvg != null
                      ? UiUtils.getSvg(
                          imgSvg!,
                          width: 24,
                          height: 24,
                          color: useOriginalSvgColor == true ? null : txtColor,
                        )
                      : Icon(leftIcon, color: txtColor),
                ),
              if (label?.isNotEmpty == true)
                Text(
                  label!,
                  style: TextStyle(
                    color: labelColor ?? txtColor,
                    fontWeight: fontWeight ?? FontWeight.bold,
                    fontSize: fontSize ?? 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  MainAxisAlignment _getMainAxisAlignment() {
    switch (contentAlignment) {
      case ButtonContentAlignment.left:
        return MainAxisAlignment.start;
      case ButtonContentAlignment.center:
      default:
        return MainAxisAlignment.center;
    }
  }

  Alignment _getMainAxisAlignmentAlign() {
    switch (contentAlignment) {
      case ButtonContentAlignment.left:
        return Alignment.centerLeft;
      case ButtonContentAlignment.center:
      default:
        return Alignment.center;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    // For outlined style, use transparent background
    if (styleType == ButtonStyleType.outlined) {
      return Colors.transparent;
    }

    switch (colorType) {
      case ButtonColorType.territory:
        return context.color.territoryColor;
      case ButtonColorType.primary:
        return context.color.primaryColor;
      case ButtonColorType.textDefault:
        return context.color.textDefaultColor;
      default:
        return context.color.error;
    }
  }

  Color _getTextColor(BuildContext context) {
    // For outlined style, use darker text color
    if (styleType == ButtonStyleType.outlined) {
      return textColor ?? context.color.textColorDark;
    }
    return textColor ?? context.color.forthColor;
  }

  // --- PHƯƠNG THỨC _getBorderSide ĐÃ ĐƯỢC HỢP NHẤT VÀ SỬA LỖI ---
  BorderSide _getBorderSide(BuildContext context) {
    // Ưu tiên borderColor / borderWidth được truyền từ bên ngoài
    if (borderColor != null || borderWidth != null) {
      return BorderSide(
        color: borderColor ?? context.color.textColorDark,
        width: borderWidth ?? 1.0,
      );
    }

    // Nếu không, dùng logic cũ
    if (styleType == ButtonStyleType.outlined) {
      return BorderSide(
        color: textColor ?? context.color.textColorDark,
        width: 2.0,
      );
    } else if (colorType == ButtonColorType.primary) {
      return const BorderSide(
        color: Color(0xFFE0E0E0),
        width: 1.0,
      );
    }
    return BorderSide.none;
  }
  // ----------------------------------------------------------------
}
