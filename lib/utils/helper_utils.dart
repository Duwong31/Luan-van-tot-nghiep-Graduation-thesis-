import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  /// Calculate distance between two coordinates
  /// Returns formatted string (e.g., "850m" or "2.5km")
  /// Returns null if any coordinate is null or calculation fails
  static String? calculateDistance({
    required double? userLat,
    required double? userLng,
    required double? targetLat,
    required double? targetLng,
  }) {
    if (userLat == null || userLng == null || targetLat == null || targetLng == null) {
      return null;
    }

    try {
      double distanceInMeters = Geolocator.distanceBetween(
        userLat,
        userLng,
        targetLat,
        targetLng,
      );

      // Convert to km and format
      if (distanceInMeters < 1000) {
        return '${distanceInMeters.toInt()}m';
      } else {
        double distanceInKm = distanceInMeters / 1000;
        return '${distanceInKm.toStringAsFixed(1)}km';
      }
    } catch (e) {
      return null;
    }
  }
}
