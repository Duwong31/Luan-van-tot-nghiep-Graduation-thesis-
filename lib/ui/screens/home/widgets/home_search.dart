import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/screens/home/home_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class HomeSearchField extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  const HomeSearchField({super.key, this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    Widget buildSearchIcon() {
      return Padding(
          padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
          child:
              UiUtils.getSvg(AppIcons.search, color: context.color.iconColor));
    }

    return Container(
        margin:
            const EdgeInsets.symmetric(horizontal: sidePadding, vertical: 15),
        width: context.screenWidth,
        height: 48,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: context.color.borderColor, width: 1),
            color: context.color.forthColor),
        child: TextFormField(
          readOnly: false,
          decoration: InputDecoration(
            border: InputBorder.none, //OutlineInputBorder()
            fillColor: Theme.of(context).colorScheme.forthColor,
            hintText: Tr.of(context)?.searchHint ?? "Search for movies...",
            hintStyle: TextStyle(
                color: context.color.textDefaultColor.withValues(alpha: 0.5)),
            prefixIcon: buildSearchIcon(),
            prefixIconConstraints:
                const BoxConstraints(minHeight: 5, minWidth: 5),
          ),
          enableSuggestions: true,
          onChanged: onSearchChanged,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
        ));
  }
}
