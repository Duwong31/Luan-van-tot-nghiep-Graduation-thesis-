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
  ///
  static String _svgPath(String name) {
    return "$_basePath$name.svg";
  }
}

class MainIcons {
  static String _base(String path) {
    return "assets/Icons/$path";
  }

  ////////
  String appIcon = _base("AppIcon/icon.png");
  String splashIcon = _base("SplashIcon/icon.png");
  String placeHolder = _base("Placeholder/icon.png");
  String homeIcon = _base("HomeIcon/icon.png");
}
