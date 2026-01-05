// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class TrVi extends Tr {
  TrVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Celes';

  @override
  String get login => 'Đăng nhập';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get loggingOut => 'Đang đăng xuất...';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get welcomeMessage => 'Chào mừng bạn quay trở lại!';

  @override
  String get home => 'Trang chủ';

  @override
  String get ticket => 'Vé';

  @override
  String get cinema => 'Rạp chiếu';

  @override
  String get searchHint => 'Tìm kiếm phim...';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get myTicket => 'Vé của tôi';

  @override
  String get paymentHistory => 'Lịch sử thanh toán';

  @override
  String get changeLanguage => 'Thay đổi ngôn ngữ';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get faceIdTouchId => 'Face ID / Touch ID';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get pressAgainToExit => 'Nhấn lại để thoát';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get logIn => 'Đăng nhập';

  @override
  String get logInTitle => 'Đăng nhập';

  @override
  String get signUpTitle => 'Đăng ký';

  @override
  String get logInSubtitle => 'Vui lòng đăng nhập để trải nghiệm thêm!';

  @override
  String get rememberMe => 'Ghi nhớ đăng nhập';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get loggingIn => 'Đang đăng nhập...';

  @override
  String get haveNotAccount => 'Chưa có tài khoản?';

  @override
  String get signUpNow => 'Đăng ký ngay';

  @override
  String get or => 'Hoặc';

  @override
  String get orContinueWith => 'Hoặc tiếp tục với';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get address => 'Địa chỉ';

  @override
  String get creatingAccount => 'Đang tạo tài khoản...';

  @override
  String get termsAndPrivacy =>
      'Bằng việc đăng nhập hoặc đăng ký, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi';

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu';

  @override
  String get resetYourPassword => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordDescription =>
      'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi hướng dẫn đặt lại mật khẩu.';

  @override
  String get sending => 'Đang gửi...';

  @override
  String get submit => 'Gửi';

  @override
  String get backToLogin => 'Quay lại đăng nhập';

  @override
  String get confirmOtpCode => 'Xác nhận mã OTP';

  @override
  String otpDescription(String email) {
    return 'Bạn chỉ cần nhập mã OTP đã được gửi đến email $email';
  }

  @override
  String get verifying => 'Đang xác minh...';

  @override
  String get continue_ => 'Tiếp tục';

  @override
  String get resendOtp => 'Gửi lại mã OTP';

  @override
  String resendOtpIn(int seconds) {
    return 'Gửi lại mã OTP sau ${seconds}s';
  }

  @override
  String get sendingOtp => 'Đang gửi...';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get createNewPassword => 'Tạo mật khẩu mới';

  @override
  String get createNewPasswordDescription =>
      'Mật khẩu mới của bạn phải khác với mật khẩu trước đó.';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get passwordMismatch => 'Mật khẩu không khớp';

  @override
  String get resetPasswordSuccess => 'Đặt lại mật khẩu thành công!';

  @override
  String get changePasswordTitle => 'Đổi mật khẩu';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get savingPassword => 'Đang lưu...';

  @override
  String get savePassword => 'Lưu mật khẩu';

  @override
  String get passwordChangedSuccess => 'Đổi mật khẩu thành công!';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get dateOfBirth => 'Ngày sinh';

  @override
  String get gender => 'Giới tính';

  @override
  String get male => 'Nam';

  @override
  String get female => 'Nữ';

  @override
  String get other => 'Khác';

  @override
  String get saving => 'Đang lưu...';

  @override
  String get save => 'Lưu';

  @override
  String get profileUpdatedSuccess => 'Cập nhật hồ sơ thành công!';

  @override
  String get payment => 'Thanh toán';

  @override
  String get paymentMethod => 'Phương thức thanh toán';

  @override
  String get numberOfSeats => 'Số ghế';

  @override
  String get seats => 'Ghế';

  @override
  String get ticketPrice => 'Giá vé';

  @override
  String get perSeat => '/ghế';

  @override
  String get discountCode => 'Mã giảm giá';

  @override
  String get apply => 'Áp dụng';

  @override
  String get cancel => 'Hủy';

  @override
  String get originalPrice => 'Giá gốc';

  @override
  String get discount => 'Giảm giá';

  @override
  String get total => 'Tổng cộng';

  @override
  String get timesUp => 'Hết thời gian!';

  @override
  String get paymentSessionExpired => 'Phiên thanh toán của bạn đã hết hạn.';

  @override
  String get ok => 'OK';

  @override
  String get paymentSuccess => 'Thanh toán thành công!';

  @override
  String get paymentFailed => 'Thanh toán thất bại!';

  @override
  String get paymentCancelled => 'Bạn đã hủy thanh toán';

  @override
  String get cannotOpenPayment =>
      'Không thể mở trang thanh toán. Vui lòng thử lại.';

  @override
  String get completePaymentIn => 'Hoàn thành thanh toán trong';

  @override
  String get payNow => 'Thanh toán ngay';

  @override
  String get selectPaymentMethod => 'Vui lòng chọn phương thức thanh toán';

  @override
  String get selectDateTime => 'Chọn ngày & giờ';

  @override
  String get today => 'Hôm nay';

  @override
  String get noShowtimes => 'Không có suất chiếu';

  @override
  String get selectShowtime => 'Vui lòng chọn suất chiếu';

  @override
  String get selectSeat => 'Chọn ghế';

  @override
  String get available => 'Còn trống';

  @override
  String get selected => 'Đã chọn';

  @override
  String get sold => 'Đã bán';

  @override
  String get vip => 'VIP';

  @override
  String get couple => 'Ghế đôi';

  @override
  String get selectAtLeastOneSeat => 'Vui lòng chọn ít nhất một ghế';

  @override
  String get buyTicket => 'Mua vé';

  @override
  String seatSelected(int count) {
    return 'Đã chọn $count ghế';
  }

  @override
  String get myTicketTitle => 'Vé của tôi';

  @override
  String get bookingIdRequired => 'Cần có mã đặt vé';

  @override
  String get retry => 'Thử lại';

  @override
  String get scanQrNote => 'Xuất trình mã này tại quầy vé để nhận vé của bạn';

  @override
  String get orderId => 'Mã đơn hàng';

  @override
  String get room => 'Phòng';

  @override
  String get seat => 'Ghế';

  @override
  String get minutes => 'phút';

  @override
  String get cannotOpenGoogleMaps => 'Không thể mở Google Maps';

  @override
  String get error => 'Lỗi';

  @override
  String get movieDetail => 'Chi tiết phim';

  @override
  String get nowShowing => 'Đang chiếu';

  @override
  String get comingSoon => 'Sắp chiếu';

  @override
  String get upcoming => 'Sắp ra mắt';

  @override
  String get movieNews => 'Tin tức phim';

  @override
  String get watchTrailer => 'Xem trailer';

  @override
  String get addToFavorites => 'Thêm vào yêu thích';

  @override
  String get removeFromFavorites => 'Xóa khỏi yêu thích';

  @override
  String get bookNow => 'Đặt vé ngay';

  @override
  String get duration => 'Thời lượng';

  @override
  String get genre => 'Thể loại';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get releaseDate => 'Ngày phát hành';

  @override
  String get description => 'Mô tả';

  @override
  String get cast => 'Diễn viên';

  @override
  String get director => 'Đạo diễn';

  @override
  String get welcomeTitle => 'Chào mừng đến với Celes';

  @override
  String get welcomeSubtitle => 'Đặt vé xem phim yêu thích dễ dàng';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get noPhoneNumber => 'Chưa có số điện thoại';

  @override
  String get noEmail => 'Chưa có email';

  @override
  String get guest => 'Khách';

  @override
  String get darkTheme => 'Giao diện tối';

  @override
  String hi(String name) {
    return 'Xin chào, $name';
  }

  @override
  String get pleaseEnterEmail => 'Vui lòng nhập email của bạn';

  @override
  String get pleaseEnterPassword => 'Vui lòng nhập mật khẩu của bạn';

  @override
  String get pleaseEnterName => 'Vui lòng nhập tên của bạn';

  @override
  String get pleaseEnterPhone => 'Vui lòng nhập số điện thoại của bạn';

  @override
  String get pleaseEnterAddress => 'Vui lòng nhập địa chỉ của bạn';

  @override
  String get pleaseEnterValidEmail => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get pleaseEnterCompleteOtp => 'Vui lòng nhập đầy đủ mã OTP';

  @override
  String get invalidCredentials => 'Email hoặc mật khẩu không đúng';

  @override
  String get accountNotVerified => 'Vui lòng xác minh email trước';

  @override
  String get emailAlreadyRegistered => 'Email này đã được đăng ký';

  @override
  String get invalidOtp => 'Mã OTP không hợp lệ. Vui lòng thử lại.';

  @override
  String get otpExpired => 'Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.';

  @override
  String get userNotFound => 'Không tìm thấy tài khoản với email này';

  @override
  String get emailNotVerified => 'Vui lòng xác minh email trước';

  @override
  String get registrationSuccess =>
      'Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.';

  @override
  String get anErrorOccurred => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get failedToResendOtp => 'Không thể gửi lại OTP. Vui lòng thử lại.';

  @override
  String get logoutConfirmTitle => 'Đăng xuất';

  @override
  String get logoutConfirmMessage => 'Bạn có chắc chắn muốn đăng xuất không?';

  @override
  String get loadingMovieInfo => 'Đang tải thông tin phim...';

  @override
  String get cannotLoadMovieInfo => 'Không thể tải thông tin phim';

  @override
  String get back => 'Quay lại';

  @override
  String get storyline => 'Cốt truyện';

  @override
  String get seeMore => 'Xem thêm';

  @override
  String get seeLess => 'Thu gọn';

  @override
  String get verifyOtpCode => 'Xác nhận mã OTP';

  @override
  String otpSentTo(String email) {
    return 'Nhập mã OTP đã được gửi đến $email';
  }

  @override
  String get otpVerifiedSuccess => 'Xác minh OTP thành công!';

  @override
  String get resettingPassword => 'Đang đặt lại...';

  @override
  String get failedToLoadProfile => 'Không thể tải hồ sơ';

  @override
  String get failedToPickImage => 'Không thể chọn ảnh';

  @override
  String get paymentDataRequired => 'Cần có dữ liệu thanh toán';

  @override
  String get close => 'Đóng';

  @override
  String get chooseCinema => 'Chọn rạp chiếu';

  @override
  String get screen => 'Màn hình';

  @override
  String get time => 'Giờ';

  @override
  String get date => 'Ngày';

  @override
  String get movieTitle => 'Tên phim';

  @override
  String get cinemaLocation => 'Vị trí rạp';

  @override
  String get seatNumber => 'Số ghế';

  @override
  String get price => 'Giá';

  @override
  String get bookingCode => 'Mã đặt vé';

  @override
  String get qrCode => 'Mã QR';

  @override
  String get stripePaymentSubtitle => 'Visa, Master, JCB, Amex';

  @override
  String get vnpayPaymentSubtitle => 'ATM, QR Code, Ví điện tử';

  @override
  String get discountLabel => 'Giảm giá';

  @override
  String get favorites => 'Yêu thích';

  @override
  String get noFavorites => 'Chưa có phim yêu thích';

  @override
  String get addToFavoritesSuccess => 'Đã thêm vào yêu thích';

  @override
  String get removeFromFavoritesSuccess => 'Đã xóa khỏi yêu thích';

  @override
  String get favoriteActionFailed => 'Thao tác thất bại. Vui lòng thử lại.';

  @override
  String get noMoviesAvailable => 'Không có phim nào';

  @override
  String get seeAll => 'Xem tất cả';
}
