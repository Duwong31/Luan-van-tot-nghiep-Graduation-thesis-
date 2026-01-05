// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class TrEn extends Tr {
  TrEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Celes';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get welcomeMessage => 'Welcome back!';

  @override
  String get home => 'Home';

  @override
  String get ticket => 'Ticket';

  @override
  String get cinema => 'Cinema';

  @override
  String get searchHint => 'Search for movies...';

  @override
  String get profile => 'Profile';

  @override
  String get myTicket => 'My ticket';

  @override
  String get paymentHistory => 'Payment history';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get changePassword => 'Change password';

  @override
  String get faceIdTouchId => 'Face ID / Touch ID';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get pressAgainToExit => 'Press again to exit';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get logIn => 'Log In';

  @override
  String get logInTitle => 'Log In';

  @override
  String get signUpTitle => 'Sign up';

  @override
  String get logInSubtitle => 'Please log in to experience more!';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get haveNotAccount => 'Have not got an account?';

  @override
  String get signUpNow => 'Sign Up Now';

  @override
  String get or => 'Or';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get creatingAccount => 'Creating account...';

  @override
  String get termsAndPrivacy =>
      'By sign in or sign up, you agree to our Terms of Service\nand Privacy Policy';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get resetYourPassword => 'Reset Your Password';

  @override
  String get resetPasswordDescription =>
      'Enter your email address and we will send you instructions to reset your password.';

  @override
  String get sending => 'Sending...';

  @override
  String get submit => 'Submit';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get confirmOtpCode => 'Confirm OTP code';

  @override
  String otpDescription(String email) {
    return 'You just need to enter the OTP sent to the registered email $email';
  }

  @override
  String get verifying => 'Verifying...';

  @override
  String get continue_ => 'Continue';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend OTP in ${seconds}s';
  }

  @override
  String get sendingOtp => 'Sending...';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get createNewPasswordDescription =>
      'Your new password must be different from your previous password.';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get resetPasswordSuccess => 'Password reset successfully!';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get savingPassword => 'Saving...';

  @override
  String get savePassword => 'Save Password';

  @override
  String get passwordChangedSuccess => 'Password changed successfully!';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get saving => 'Saving...';

  @override
  String get save => 'Save';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String get payment => 'Payment';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get numberOfSeats => 'Number of seats';

  @override
  String get seats => 'Seats';

  @override
  String get ticketPrice => 'Ticket price';

  @override
  String get perSeat => '/seat';

  @override
  String get discountCode => 'Discount code';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get originalPrice => 'Original price';

  @override
  String get discount => 'Discount';

  @override
  String get total => 'Total';

  @override
  String get timesUp => 'Time\'s Up!';

  @override
  String get paymentSessionExpired => 'Your payment session has expired.';

  @override
  String get ok => 'OK';

  @override
  String get paymentSuccess => 'Payment successful!';

  @override
  String get paymentFailed => 'Payment failed!';

  @override
  String get paymentCancelled => 'You have cancelled the payment';

  @override
  String get cannotOpenPayment => 'Cannot open payment page. Please try again.';

  @override
  String get completePaymentIn => 'Complete payment in';

  @override
  String get payNow => 'Pay Now';

  @override
  String get selectPaymentMethod => 'Please select a payment method';

  @override
  String get selectDateTime => 'Select Date & Time';

  @override
  String get today => 'Today';

  @override
  String get noShowtimes => 'No showtimes available';

  @override
  String get selectShowtime => 'Please select a showtime';

  @override
  String get selectSeat => 'Select Seat';

  @override
  String get available => 'Available';

  @override
  String get selected => 'Selected';

  @override
  String get sold => 'Sold';

  @override
  String get vip => 'VIP';

  @override
  String get couple => 'Couple';

  @override
  String get selectAtLeastOneSeat => 'Please select at least one seat';

  @override
  String get buyTicket => 'Buy Ticket';

  @override
  String seatSelected(int count) {
    return '$count seat(s) selected';
  }

  @override
  String get myTicketTitle => 'My Ticket';

  @override
  String get bookingIdRequired => 'Booking ID is required';

  @override
  String get retry => 'Retry';

  @override
  String get scanQrNote =>
      'Present this code at the ticket counter to receive your ticket';

  @override
  String get orderId => 'Order ID';

  @override
  String get room => 'Room';

  @override
  String get seat => 'Seat';

  @override
  String get minutes => 'minutes';

  @override
  String get cannotOpenGoogleMaps => 'Cannot open Google Maps';

  @override
  String get error => 'Error';

  @override
  String get movieDetail => 'Movie Detail';

  @override
  String get nowShowing => 'Now Showing';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get movieNews => 'Movie News';

  @override
  String get watchTrailer => 'Watch Trailer';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get bookNow => 'Book Now';

  @override
  String get duration => 'Duration';

  @override
  String get genre => 'Genre';

  @override
  String get language => 'Language';

  @override
  String get releaseDate => 'Release Date';

  @override
  String get description => 'Description';

  @override
  String get cast => 'Cast';

  @override
  String get director => 'Director';

  @override
  String get welcomeTitle => 'Welcome to Celes';

  @override
  String get welcomeSubtitle => 'Book your favorite movie tickets easily';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get noPhoneNumber => 'No phone number';

  @override
  String get noEmail => 'No email';

  @override
  String get guest => 'Guest';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String hi(String name) {
    return 'Hi, $name';
  }

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get pleaseEnterAddress => 'Please enter your address';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';

  @override
  String get pleaseEnterCompleteOtp => 'Please enter the complete OTP code';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get accountNotVerified => 'Please verify your email first';

  @override
  String get emailAlreadyRegistered => 'This email is already registered';

  @override
  String get invalidOtp => 'Invalid OTP code. Please try again.';

  @override
  String get otpExpired => 'OTP code has expired. Please request a new one.';

  @override
  String get userNotFound => 'No account found with this email';

  @override
  String get emailNotVerified => 'Please verify your email first';

  @override
  String get registrationSuccess =>
      'Registration successful! Please sign in to continue.';

  @override
  String get anErrorOccurred => 'An error occurred. Please try again.';

  @override
  String get failedToResendOtp => 'Failed to resend OTP. Please try again.';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get loadingMovieInfo => 'Loading movie info...';

  @override
  String get cannotLoadMovieInfo => 'Cannot load movie info';

  @override
  String get back => 'Back';

  @override
  String get storyline => 'Storyline';

  @override
  String get seeMore => 'See more';

  @override
  String get seeLess => 'See less';

  @override
  String get verifyOtpCode => 'Verify OTP Code';

  @override
  String otpSentTo(String email) {
    return 'Enter the OTP code sent to $email';
  }

  @override
  String get otpVerifiedSuccess => 'OTP verified successfully!';

  @override
  String get resettingPassword => 'Resetting...';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get failedToPickImage => 'Failed to pick image';

  @override
  String get paymentDataRequired => 'Payment data is required';

  @override
  String get close => 'Close';

  @override
  String get chooseCinema => 'Choose Cinema';

  @override
  String get screen => 'Screen';

  @override
  String get time => 'Time';

  @override
  String get date => 'Date';

  @override
  String get movieTitle => 'Movie Title';

  @override
  String get cinemaLocation => 'Cinema Location';

  @override
  String get seatNumber => 'Seat Number';

  @override
  String get price => 'Price';

  @override
  String get bookingCode => 'Booking Code';

  @override
  String get qrCode => 'QR Code';

  @override
  String get stripePaymentSubtitle => 'Visa, Master, JCB, Amex';

  @override
  String get vnpayPaymentSubtitle => 'ATM, QR Code, E-Wallet';

  @override
  String get discountLabel => 'Discount';

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavorites => 'No favorite movies yet';

  @override
  String get addToFavoritesSuccess => 'Added to favorites';

  @override
  String get removeFromFavoritesSuccess => 'Removed from favorites';

  @override
  String get favoriteActionFailed => 'Action failed. Please try again.';

  @override
  String get noMoviesAvailable => 'No movies available';

  @override
  String get seeAll => 'See all';
}
