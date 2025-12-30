import 'package:Celes/app/app_theme.dart';
import 'package:Celes/data/cubits/system/app_theme_cubit.dart';
import 'package:Celes/settings.dart';
import 'package:Celes/utils/constant.dart';
import 'package:Celes/utils/extensions/lib/translate.dart';
import 'package:Celes/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  // static BuildContext? currContext;
  static String paymentIntentSuccessResponse = "succeeded";

  static void initStripe(String? stripeId, String? stripeMode) async {
    if (AppSettings.stripeStatus == 1) {
      Stripe.publishableKey = stripeId ?? '';
      Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
      Stripe.urlScheme = 'flutterstripe';
      await Stripe.instance.applySettings();
    }
  }

  static dynamic payWithPaymentSheet({
    required BuildContext context,
    String amount = "0",
    String currency = 'INR',
    String clientSecret = '',
    String paymentIntentId = '',
    String merchantDisplayName = "",
    Function(bool success, String? message)? onPaymentResult,
  }) async {
    try {
      // currContext = bcontext;
      //setting up Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: context.read<AppThemeCubit>().state.appTheme == AppTheme.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
                  address: AddressCollectionMode.full,
                  email: CollectionMode.always,
                  name: CollectionMode.always,
                  phone: CollectionMode.always),
          merchantDisplayName: merchantDisplayName,
        ),
      );

      //open payment sheet
      displayPaymentSheet(context, onPaymentResult: onPaymentResult);
    } catch (e) {
      if (onPaymentResult != null) {
        onPaymentResult(false, e.toString());
      }
      throw Exception(e.toString());
    }
  }

  static void displayPaymentSheet(BuildContext context, {Function(bool success, String? message)? onPaymentResult}) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      String successMessage = "paymentSuccessfullyCompleted"
          .translate(Constant.navigatorKey.currentContext!);
      
      HelperUtils.showSnackBarMessage(
          Constant.navigatorKey.currentContext!, successMessage);
      
      if (onPaymentResult != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          onPaymentResult(true, successMessage);
        });
      } else {
        // Fallback to old behavior for subscription payments
        Future.delayed(Duration.zero, () {
          Navigator.of(Constant.navigatorKey.currentContext!).popUntil((route) => route.isFirst);
        });
      }
    } on Exception catch (e) {
      String errorMessage = '';
      if (e is StripeException) {
        errorMessage = 'Error from Stripe: ${e.error.localizedMessage}';
      } else {
        errorMessage = 'Unforeseen error: ${e}';
      }
      
      HelperUtils.showSnackBarMessage(Constant.navigatorKey.currentContext!, errorMessage);
      
      if (onPaymentResult != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          onPaymentResult(false, errorMessage);
        });
      }
    }
  }

  static StripeTransactionResponse getPlatformExceptionErrorResult(err) {
    String message = "Something went wrong";
    if (err.code == 'cancelled') {
      message = "Transaction is cancelled";
    }
    return StripeTransactionResponse(
      message: message,
      success: false,
      status: 'cancelled',
    );
  }
}

class StripeTransactionResponse {
  final String? message, status;
  bool? success;

  StripeTransactionResponse({this.message, this.success, this.status});
}
