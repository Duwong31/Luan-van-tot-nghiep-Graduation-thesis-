import 'package:Celes/data/cubits/booking/booking_cubit.dart';
import 'package:Celes/data/cubits/booking/calculate_price_cubit.dart';
import 'package:Celes/data/models/seat_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/settings.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/lib/build_context.dart';
import 'package:Celes/utils/helper_utils.dart';
import 'package:Celes/utils/payment/gateaways/payment_webview.dart';
import 'package:Celes/utils/payment/gateaways/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:Celes/ui/screens/ticket/my_ticket_screen.dart';
import 'package:Celes/data/models/voucher_model.dart';
import 'package:Celes/ui/screens/payment/widgets/voucher_bottom_sheet.dart';

/// Data class for payment screen
class PaymentData {
  final String movieTitle;
  final String? movieImage;
  final String genres;
  final String cinemaName;
  final String showtime;
  final String date;
  final List<Seat> selectedSeats;
  final int ticketPrice;
  final int showtimeId;
  final int roomNumber;

  PaymentData({
    required this.movieTitle,
    this.movieImage,
    required this.genres,
    required this.cinemaName,
    required this.showtime,
    required this.date,
    required this.selectedSeats,
    required this.ticketPrice,
    required this.showtimeId,
    required this.roomNumber,
  });

  /// Get formatted seat labels (e.g., "A1, A2, B5")
  String get seatLabels => selectedSeats.map((s) => s.label).join(', ');

  /// Get total price
  int get totalPrice => selectedSeats.length * ticketPrice;

  /// Get formatted total price
  String get formattedTotalPrice {
    return '${totalPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} VND';
  }
}

class PaymentScreen extends StatefulWidget {
  final PaymentData paymentData;

  const PaymentScreen({
    Key? key,
    required this.paymentData,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();

  static Route route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as PaymentData?;
    if (args == null) {
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text(Tr.of(context)!.paymentDataRequired)),
        ),
      );
    }
    return MaterialPageRoute(
      builder: (_) => PaymentScreen(paymentData: args),
    );
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _discountController = TextEditingController();
  String? _selectedPaymentMethod;
  int _remainingSeconds = 600; // 10:00 minutes
  Timer? _timer;
  bool _isProcessing = false;
  int? _currentBookingId;

  PaymentData get data => widget.paymentData;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _calculatePrice();
  }

  void _calculatePrice({String? voucherCode}) {
    context.read<CalculatePriceCubit>().calculatePrice(
          showtimeId: data.showtimeId,
          seatIds: data.selectedSeats.map((s) => s.id).toList(),
          voucherCode: voucherCode,
        );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _showTimeoutDialog();
      }
    });
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(Tr.of(context)!.timesUp),
        content: Text(Tr.of(context)!.paymentSessionExpired),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(Tr.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingLoading) {
          setState(() => _isProcessing = true);
        } else {
          setState(() => _isProcessing = false);
        }

        if (state is BookingCreated) {
          _handlePaymentCreated(state);
        } else if (state is BookingError) {
          HelperUtils.showSnackBarMessage(context, state.errorMessage);
        }
      },
      child: _buildBody(),
    );
  }

  void _handlePaymentCreated(BookingCreated state) {
    final payment = state.payment;

    // Save booking ID for later navigation
    _currentBookingId = state.booking.id;

    // Check if we have checkout URL (works for both VNPay and Stripe Checkout)
    if (payment.hasCheckoutUrl) {
      // Open WebView for payment
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebView(
            authorizationUrl: payment.checkoutUrl!,
            reference: state.bookingCode,
            onSuccess: (ref) => _onPaymentSuccess(ref),
            onFailed: (ref) => _onPaymentFailed(ref),
            onCancel: () => _onPaymentCancelled(),
          ),
        ),
      );
    } else if (payment.isStripe && payment.hasClientSecret) {
      // Open Stripe Payment Sheet (when API returns client_secret)
      StripeService.payWithPaymentSheet(
        context: context,
        clientSecret: payment.clientSecret!,
        merchantDisplayName: AppSettings.applicationName,
        onPaymentResult: (success, message) {
          if (success) {
            _onPaymentSuccess(state.bookingCode);
          } else {
            _onPaymentFailed(state.bookingCode);
          }
        },
      );
    } else {
      // No valid payment URL
      HelperUtils.showSnackBarMessage(
        context,
        Tr.of(context)!.cannotOpenPayment,
      );
    }
  }

  void _onPaymentSuccess(String bookingCode) {
    if (!mounted) return;

    HelperUtils.showSnackBarMessage(context, Tr.of(context)!.paymentSuccess);

    // Navigate to ticket screen with booking ID
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      if (_currentBookingId != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MyTicketScreen(bookingId: _currentBookingId!),
          ),
          (route) => route.isFirst,
        );
      }
    });
  }

  void _onPaymentFailed(String bookingCode) {
    if (!mounted) return;
    HelperUtils.showSnackBarMessage(context, Tr.of(context)!.paymentFailed);
  }

  void _onPaymentCancelled() {
    if (!mounted) return;
    HelperUtils.showSnackBarMessage(context, Tr.of(context)!.paymentCancelled);
  }

  void _processPayment() {
    if (_selectedPaymentMethod == null) return;

    // Get voucher code if applied
    final priceState = context.read<CalculatePriceCubit>().state;
    String? voucherCode;
    if (priceState is CalculatePriceLoaded && priceState.hasVoucher) {
      voucherCode = priceState.voucherCode;
    }

    // Create booking
    context.read<BookingCubit>().createBooking(
          showtimeId: data.showtimeId,
          seatIds: data.selectedSeats.map((s) => s.id).toList(),
          paymentMethod: _selectedPaymentMethod!,
          voucherCode: voucherCode,
        );
  }

  void _showVoucherBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => VoucherBottomSheet(
          currentVoucherCode: _discountController.text.isNotEmpty
              ? _discountController.text
              : null,
          onVoucherSelected: (Voucher voucher) {
            // Set voucher code in text field
            _discountController.text = voucher.code;

            // Automatically apply the voucher
            context.read<CalculatePriceCubit>().applyVoucher(voucher.code);
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          Tr.of(context)!.payment,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Info Card
              _buildMovieInfoCard(),
              const SizedBox(height: 20),

              // Order Details
              _buildOrderDetails(),
              const SizedBox(height: 20),

              // Discount Code
              _buildDiscountSection(),
              const SizedBox(height: 24),

              // Total Price
              _buildTotalPrice(),
              const SizedBox(height: 24),

              // Payment Method Section
              Text(
                Tr.of(context)!.paymentMethod,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Payment Options - Stripe & VNPay
              _buildPaymentOption(
                'Stripe',
                AppIcons.stripePng,
                'stripe',
                subtitle: Tr.of(context)!.stripePaymentSubtitle,
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'VNPay',
                AppIcons.vnpayPng,
                'vnpay',
                subtitle: Tr.of(context)!.vnpayPaymentSubtitle,
              ),
              const SizedBox(height: 24),

              // Timer
              _buildTimer(),
              const SizedBox(height: 16),

              // Continue Button
              _buildContinueButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Movie Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: data.movieImage != null
                ? Image.network(
                    data.movieImage!,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildMoviePlaceholder();
                    },
                  )
                : _buildMoviePlaceholder(),
          ),
          const SizedBox(width: 12),
          // Movie Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.movieTitle,
                  style: TextStyle(
                    color: context.color.textDefaultColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.theaters, size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data.genres,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${data.cinemaName} - Rạp ${data.roomNumber}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(
                      '${data.date} - ${data.showtime}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePlaceholder() {
    return Container(
      width: 60,
      height: 80,
      color: Colors.grey[800],
      child: const Icon(Icons.movie, color: Colors.white54),
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      children: [
        _buildDetailRow(
            Tr.of(context)!.numberOfSeats, '${data.selectedSeats.length}'),
        const SizedBox(height: 8),
        _buildDetailRow(Tr.of(context)!.seats, data.seatLabels),
        const SizedBox(height: 8),
        _buildDetailRow(
          Tr.of(context)!.ticketPrice,
          '${data.ticketPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND${Tr.of(context)!.perSeat}',
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return BlocBuilder<CalculatePriceCubit, CalculatePriceState>(
      builder: (context, state) {
        final bool isLoading = state is CalculatePriceLoading;
        final bool hasVoucher =
            state is CalculatePriceLoaded && state.hasVoucher;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(8),
                      border: hasVoucher
                          ? Border.all(color: Colors.green, width: 1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hasVoucher ? Icons.check_circle : Icons.discount,
                          color: hasVoucher ? Colors.green : Colors.white54,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: !hasVoucher
                                ? () => _showVoucherBottomSheet(context)
                                : null,
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _discountController,
                                enabled: !hasVoucher,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: hasVoucher
                                      ? _discountController.text
                                      : Tr.of(context)!.discountCode,
                                  hintStyle: TextStyle(
                                    color: hasVoucher
                                        ? Colors.green
                                        : Colors.white38,
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: !hasVoucher
                                      ? Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white38,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          if (hasVoucher) {
                            // Remove voucher
                            _discountController.clear();
                            context.read<CalculatePriceCubit>().removeVoucher();
                          } else if (_discountController.text.isNotEmpty) {
                            // Apply voucher
                            context
                                .read<CalculatePriceCubit>()
                                .applyVoucher(_discountController.text.trim());
                          }
                        },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: hasVoucher
                          ? Colors.red
                          : context.color.territoryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              hasVoucher
                                  ? Tr.of(context)!.cancel
                                  : Tr.of(context)!.apply,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            // Error message
            if (state is CalculatePriceError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTotalPrice() {
    return BlocBuilder<CalculatePriceCubit, CalculatePriceState>(
      builder: (context, state) {
        String totalPriceText = data.formattedTotalPrice;
        int originalPrice = data.totalPrice;
        int discount = 0;
        bool hasVoucher = false;

        if (state is CalculatePriceLoaded) {
          totalPriceText = state.formattedTotalPrice;
          originalPrice = state.price;
          discount = state.discount;
          hasVoucher = state.hasVoucher;
        }

        return Column(
          children: [
            // Original price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Tr.of(context)!.originalPrice,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${originalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Discount
            if (hasVoucher) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Tr.of(context)!.discountLabel,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '-${discount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Tr.of(context)!.total,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  totalPriceText,
                  style: TextStyle(
                    color: context.color.territoryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption(
    String title,
    String imagePath,
    String value, {
    String? subtitle,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFA726) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Payment Icon
            SizedBox(
              width: 48,
              height: 32,
              child: Center(
                child: _buildPaymentIcon(imagePath),
              ),
            ),
            const SizedBox(width: 12),
            // Payment Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Check icon for selected
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.color.territoryColor,
                size: 24,
              )
            else
              const Icon(
                Icons.chevron_right,
                color: Colors.white54,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(String iconPath) {
    // Check if the file is PNG or SVG
    if (iconPath.endsWith('.png')) {
      return Image.asset(
        iconPath,
        width: 40,
        height: 28,
        fit: BoxFit.contain,
      );
    } else {
      return SvgPicture.asset(
        iconPath,
        width: 40,
        height: 28,
        fit: BoxFit.contain,
      );
    }
  }

  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff260D08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            Tr.of(context)!.completePaymentIn,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            _formatTime(_remainingSeconds),
            style: TextStyle(
              color: context.color.territoryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final bool isLoading = state is BookingLoading || _isProcessing;

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (_selectedPaymentMethod != null && !isLoading)
                ? _processPayment
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.color.territoryColor,
              disabledBackgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    Tr.of(context)!.payNow,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
