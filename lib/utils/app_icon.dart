class AppIcons {
  //
  AppIcons._();

  //
  static const String _basePath = "assets/svg/";

  static final MainIcons main = MainIcons();

  ///Bottom nav icons
  static String homeNav = _svgPath("bottomnav/home");
  static String homeNavActive = _svgPath("bottomnav/home_active");
  static String ticketNav = _svgPath("bottomnav/ticket");
  static String ticketNavActive = _svgPath("bottomnav/ticket_active");
  static String cinemaNav = _svgPath("bottomnav/cinema");
  static String cinemaNavActive = _svgPath("bottomnav/cinema_active");
  static String profileNav = _svgPath("bottomnav/profile");
  static String profileNavActive = _svgPath("bottomnav/profile_active");
  static String nameApp = _svgPath("name_app");
  static String eyes = _svgPath("eyes");
  static String eyes_close = _svgPath("eyes_close");
  static String facebook = _svgPath("facebook");
  static String google = _svgPath("google");
  static String darkTheme = _svgPath("dark_theme");
  static String arrowRight = _svgPath("arrow_right");
  static String arrowLeft = _svgPath("arrow_left");
  static String notification_dark = _svgPath("notification");
  static String calendar = _svgPath("calendar");
  static String search = _svgPath("search");
  static String cgv = _svgPath("cgv");
  static String arrow_left = _svgPath("arrow-left");
  static String play = _svgPath("play");
  static String Face_ID = _svgPath("Face_ID");
  static String lock = _svgPath("lock");
  static String shopping_cart = _svgPath("shopping_cart");
  static String ticket_2 = _svgPath("ticket_2");
  static String translate = _svgPath("translate");
  static String stripe = _svgPath("stripe");
  static String vnpay = _svgPath("vnpay");
  static String stripePng = "assets/svg/stripe.png";
  static String vnpayPng = "assets/svg/vnpay.png";
  static String clock = _svgPath("clock");
  static String location = _svgPath("location");
  static String moneySend = _svgPath("money-send");
  static String note = _svgPath("note");
  static String seat = _svgPath("seat");
  static String video = _svgPath("video");
  static String biometricFingerprint = _svgPath("biometric-authentication");

  ///
  static String _svgPath(String name) {
    return "$_basePath$name.svg";
  }
}

class MainIcons {
  static String _base(String path) {
    return "assets/$path";
  }

  String appIcon = _base("logo.png");
}
