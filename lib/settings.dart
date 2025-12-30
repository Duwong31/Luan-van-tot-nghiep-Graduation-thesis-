import 'package:Celes/utils/helper_utils.dart';

class AppSettings {
  static const String applicationName = 'Celes';
  static const String packageName = 'com.celes.app';

  static const String hostUrl = "https://vnsportify.space";

  ///API Setting

  static const int apiDataLoadLimit = 20;
  static const int maxCategoryShowLengthInHomeScreen = 5;
  static const String apiKey = "SKT-T1";
  static final String baseUrl = "${HelperUtils.checkHost(hostUrl)}api/";

  static List<PaymentGateway> paymentGateways = [];

  static void updatePaymentGateways() {
    paymentGateways = [
      PaymentGateway(
        name: "Stripe",
        key: stripePublishableKey,
        currency: stripeCurrency,
        status: stripeStatus,
        type: "stripe",
      ),
      // PaymentGateway(
      //   name: "BankTransfer",
      //   status: bankTransferStatus,
      //   type: "bankTransfer",
      //   bankName: bankName,
      //   bankIfscSwiftCode: bankIfscSwiftCode,
      //   bankAccountHolderName: bankAccountHolderName,
      //   bankAccountNumber: bankAccountNumber,
      // ),
    ];
  }

  static String stripeCurrency = "";
  static String stripePublishableKey = "";
  static int stripeStatus = 1;

  static List<PaymentGateway> getEnabledPaymentGateways() {
    return paymentGateways.where((gateway) => gateway.status == 1).toList();
  }
}

class PaymentGateway {
  final String name;
  final String? key;
  final String? currency;
  final int status;
  final String type;
  final String? bankAccountHolderName;
  final String? bankAccountNumber;
  final String? bankName;
  final String? bankIfscSwiftCode;

  PaymentGateway({
    required this.name,
    this.key,
    this.currency,
    required this.status,
    required this.type,
    this.bankAccountHolderName,
    this.bankAccountNumber,
    this.bankIfscSwiftCode,
    this.bankName,
  });
}