import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Celes/ui/screens/ticket/my_ticket_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (_) => const PaymentScreen(),
    );
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _discountController = TextEditingController();
  String? _selectedPaymentMethod;
  int _remainingSeconds = 900; // 15:00 minutes
  Timer? _timer;

  // Hardcoded movie data for demonstration
  final String movieTitle = 'Avengers: Infinity War';
  final String movieImage =
      'https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg';
  final List<String> genres = ['Action', 'adventure', 'sci-fi'];
  final String showtime = '10.12.2022 - 14:15';
  final String orderId = '78889377726';
  final String seat = 'H7, H8';
  final double totalPrice = 189.000;

  @override
  void initState() {
    super.initState();
    _startTimer();
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
        title: const Text('Time\'s Up!'),
        content: const Text('Your payment session has expired.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
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
              const Text(
                'Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Payment Options
              _buildPaymentOption(
                'Zalo Pay',
                'assets/images/zalopay.png',
                'zalopay',
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'MoMo',
                'assets/images/momo.png',
                'momo',
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'Shopee Pay',
                'assets/images/shopeepay.png',
                'shopeepay',
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'ATM Card',
                'assets/images/atm.png',
                'atm',
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'International payments',
                'assets/images/cards.png',
                'international',
                subtitle: 'Visa, Master, JCB, Amex',
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
            child: Image.network(
              movieImage,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 80,
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.white54),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Movie Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieTitle,
                  style: const TextStyle(
                    color: Color(0xFFFFA726),
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
                        genres.join(', '),
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
                    const Text(
                      'Vincom Ocean Park CGV',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
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
                      showtime,
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

  Widget _buildOrderDetails() {
    return Column(
      children: [
        _buildDetailRow('Order ID', orderId),
        const SizedBox(height: 8),
        _buildDetailRow('Seat', seat),
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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.discount, color: Colors.white54, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _discountController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'discount code',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFA726),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'Apply',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${totalPrice.toStringAsFixed(3)} VND',
          style: const TextStyle(
            color: Color(0xFFFFA726),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: _buildPaymentIcon(value),
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
            // Arrow Icon
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(String value) {
    // Placeholder icons - replace with actual images
    switch (value) {
      case 'zalopay':
        return const Text('Zalo',
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue));
      case 'momo':
        return const Text('momo',
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.pink));
      case 'shopeepay':
        return const Text('Shopee',
            style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.orange));
      case 'atm':
        return const Icon(Icons.credit_card, size: 20, color: Colors.blue);
      case 'international':
        return const Icon(Icons.credit_card, size: 20, color: Colors.grey);
      default:
        return const Icon(Icons.payment, size: 20);
    }
  }

  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text(
            'Complete your payment in',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            _formatTime(_remainingSeconds),
            style: const TextStyle(
              color: Color(0xFFFFA726),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _selectedPaymentMethod != null
            ? () {
                // Navigate to payment processing or ticket screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyTicketScreen(),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF3D00),
          disabledBackgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
