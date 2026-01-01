import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final bool autoFocus;
  const SearchScreen({super.key, required this.autoFocus});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        leading: BackButton(color: context.color.textDefaultColor),
        title: Container(
            height: 48,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: context.color.borderColor, width: 1),
                color: context.color.forthColor),
            child: TextFormField(
                controller: _searchController,
                autofocus: widget.autoFocus,
                style: TextStyle(color: context.color.textDefaultColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.forthColor,
                  hintText: "Search for movies...",
                  hintStyle: TextStyle(
                      color: context.color.textDefaultColor
                          .withValues(alpha: 0.5)),
                  prefixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 12.0, end: 12),
                      child: UiUtils.getSvg(AppIcons.search,
                          color: context.color.iconColor)),
                  prefixIconConstraints:
                      const BoxConstraints(minHeight: 5, minWidth: 5),
                  contentPadding: const EdgeInsetsDirectional.only(bottom: 0),
                ),
                enableSuggestions: true,
                onFieldSubmitted: (value) {
                  // Perform search
                })),
      ),
      body: Center(
        child: Text(
          "Type to search movies",
          style: TextStyle(color: context.color.textDefaultColor),
        ),
      ),
    );
  }
}
