import 'package:Celes/app/app_routes.dart';
import 'package:Celes/ui/screens/home/home_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/extensions/lib/translate.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildSearchIcon() {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
        child: UiUtils.getSvg(AppIcons.search,
          color: context.color.territoryColor));
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, Routes.searchScreenRoute, arguments: {
          "autoFocus": true,
        });
      },
      child: AbsorbPointer(
        absorbing: true,
        child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: sidePadding, vertical: 15),
            width: context.screenWidth,
            height: 48,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: context.color.secondaryColor),
            child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none, //OutlineInputBorder()
                  fillColor: Theme.of(context).colorScheme.secondaryColor,
                  hintText: "searchHintLbl".translate(context),
                  hintStyle: TextStyle(
                      color: context.color.textDefaultColor
                          .withValues(alpha: 0.5)),
                  prefixIcon: buildSearchIcon(),
                  prefixIconConstraints:
                      const BoxConstraints(minHeight: 5, minWidth: 5),
                ),
                enableSuggestions: true,
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onTap: () {
                  //change prefix icon color to primary
                })),
      ),
    );
  }
}
