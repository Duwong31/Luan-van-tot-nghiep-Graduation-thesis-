import 'package:Celes/utils/helper_utils.dart';
class AppSettings {
  /// Basic Settings

  static const String applicationName = 'Celes';
  static const String packageName = 'com.celes.app';

  static const String hostUrl = "";

  ///API Setting

  static const int apiDataLoadLimit = 20;
  static const int maxCategoryShowLengthInHomeScreen = 5;

  static final String baseUrl = "${HelperUtils.checkHost(hostUrl)}api/";
}
