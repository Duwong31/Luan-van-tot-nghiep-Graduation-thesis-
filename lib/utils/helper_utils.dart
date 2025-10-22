import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';

enum MessageType {
  success(successMessageColor),
  warning(warningMessageColor),
  error(errorMessageColor);

  final Color value;

  const MessageType(this.value);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class HelperUtils {
  static String checkHost(String url) {
    if (url.endsWith("/")) {
      return url;
    } else {
      return "$url/";
    }
  }

  static void killPreviousPages(BuildContext context, var nextpage, var args) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(nextpage, (route) => false, arguments: args);
  }

  static String setFirstLetterUppercase(String value) {
    if (value.isNotEmpty) value = value.replaceAll("_", ' ');
    return value.toTitleCase();
  }

  static dynamic showSnackBarMessage(BuildContext context, String message,
      {int messageDuration = 3,
      MessageType? type,
      bool? isFloating,
      VoidCallback? onClose,
      SnackBarAction? snackBarAction}) async {
    var snackBar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(message),
        behavior: (isFloating ?? false) ? SnackBarBehavior.floating : null,
        backgroundColor: type?.value,
        duration: Duration(seconds: messageDuration),
        action: snackBarAction,
      ),
    );
    var snackBarClosedReason = await snackBar.closed;
    if (SnackBarClosedReason.values.contains(snackBarClosedReason)) {
      onClose?.call();
    }
  }
}
