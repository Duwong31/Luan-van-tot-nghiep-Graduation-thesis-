import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class SeeAllButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;

  const SeeAllButton({
    super.key,
    this.text,
    this.onTap,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.iconSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text ?? Tr.of(context)!.seeAll,
            style: TextStyle(
              fontSize: fontSize,
              color: context.color.territoryColor,
              fontWeight: fontWeight,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_forward_ios,
            size: iconSize,
            color: context.color.territoryColor,
          ),
        ],
      ),
    );
  }
}
