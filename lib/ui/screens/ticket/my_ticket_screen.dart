import 'package:Celes/app/app_routes.dart';
import 'package:Celes/data/cubits/booking/booking_cubit.dart';
import 'package:Celes/data/models/booking_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/lib/build_context.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTicketScreen extends StatefulWidget {
  final int? bookingId;

  const MyTicketScreen({
    Key? key,
    this.bookingId,
  }) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final bookingId = routeSettings.arguments as int?;
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => BookingCubit(),
        child: MyTicketScreen(bookingId: bookingId),
      ),
    );
  }

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    if (widget.bookingId != null) {
      context.read<BookingCubit>().getBookingDetail(widget.bookingId!);
    } else {
      context.read<BookingCubit>().fetchUserBookings(status: 'confirmed');
    }
  }

  /// Open Google Maps with destination coordinates
  Future<void> _openGoogleMaps(double lat, double lng, String? label) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    // Alternative: Use directions mode
    // final Uri googleMapsUrl = Uri.parse(
    //   'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    // );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Tr.of(context)!.cannotOpenGoogleMaps),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${Tr.of(context)!.error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: widget.bookingId != null,
        leading: widget.bookingId != null
            ? IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          Tr.of(context)!.myTicketTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingDetailLoading || state is MyBookingsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is BookingDetailLoaded) {
            return _buildTicketDetail(state.booking);
          } else if (state is MyBookingsLoaded) {
            if (state.bookings.isEmpty) {
              return _buildEmptyState();
            }
            return _buildTicketList(state.bookings);
          } else if (state is BookingDetailError) {
            return _buildErrorState(state.errorMessage);
          } else if (state is MyBookingsError) {
            return _buildErrorState(state.errorMessage);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tickets found',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text(Tr.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList(List<Booking> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildTicketListItem(bookings[index]);
      },
    );
  }

  Widget _buildTicketListItem(Booking booking) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.myTicket,
          arguments: booking.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Movie Poster
                SizedBox(
                  width: 80,
                  height: 110,
                  child: booking.moviePoster != null
                      ? Image.network(
                          booking.moviePoster!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPosterPlaceholderSmall(),
                        )
                      : _buildPosterPlaceholderSmall(),
                ),
                // Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.movieTitle ?? 'Unknown Movie',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${booking.showtimeDate} • ${booking.showtimeTime}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.cinemaName ?? 'Cinema',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white54),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterPlaceholderSmall() {
    return Container(
      width: 80,
      height: 110,
      color: Colors.grey[800],
      child: const Icon(Icons.movie, color: Colors.white24, size: 30),
    );
  }

  Widget _buildTicketDetail(Booking booking) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: _buildTicketCard(context, booking),
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Booking booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          // Top Section - Movie Info
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Poster
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13.36),
                      child: booking.moviePoster != null
                          ? Image.network(
                              booking.moviePoster!,
                              width: 125,
                              height: 177,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPosterPlaceholder();
                              },
                            )
                          : _buildPosterPlaceholder(),
                    ),
                    const SizedBox(width: 16),
                    // Movie Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.movieTitle ?? 'Unknown Movie',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Duration
                          if (booking.movieDuration != null)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.clock,
                                  width: 20,
                                  height: 20,
                                ),
                                // Icon(
                                //   Icons.access_time,
                                //   size: 20,
                                //   color: Colors.grey[800],
                                // ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.movieDuration!,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 4),
                          // Genres
                          if (booking.movieGenre != null)
                            Row(
                              children: [
                                // Icon(
                                //   Icons.movie,
                                //   size: 20,
                                //   color: Colors.grey[800],
                                // ),
                                SvgPicture.asset(
                                  AppIcons.video,
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.movieGenre!,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date and Seat Info
                Row(
                  children: [
                    // Date and Time
                    Expanded(
                      child: Row(
                        children: [
                          // Icon(
                          //   Icons.calendar_today,
                          //   size: 48,
                          //   color: Colors.grey[800],
                          // ),
                          SvgPicture.asset(
                            AppIcons.calendar,
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.showtimeTime ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                booking.showtimeDate ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Seat Info
                    Expanded(
                      child: Row(
                        children: [
                          // Icon(
                          //   Icons.event_seat,
                          //   size: 48,
                          //   color: Colors.grey[800],
                          // ),
                          SvgPicture.asset(
                            AppIcons.seat,
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.roomName ?? 'Room',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Seat ${booking.seatLabels}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Divider line
                Container(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),

                // Price
                Row(
                  children: [
                    // Icon(
                    //   Icons.attach_money,
                    //   size: 24,
                    //   color: Colors.grey[800],
                    // ),
                    SvgPicture.asset(
                      AppIcons.moneySend,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      booking.formattedTotalPrice,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Cinema Location
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.location,
                      width: 24,
                      height: 24,
                    ),
                    // Icon(
                    //   Icons.location_on,
                    //   size: 24,
                    //   color: Colors.grey[800],
                    // ),
                    const SizedBox(width: 8),
                    Text(
                      booking.showtime?.cinemaName ?? 'Cinema',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Celes Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.color.territoryColor),
                      ),
                      child: Text(
                        'Celes',
                        style: TextStyle(
                          color: context.color.territoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Address - Tappable to open Google Maps
                if (booking.showtime?.cinemaAddress != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: GestureDetector(
                      onTap: booking.hasCinemaCoordinates
                          ? () => _openGoogleMaps(
                                booking.cinemaLat!,
                                booking.cinemaLng!,
                                booking.cinemaName,
                              )
                          : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              booking.showtime!.cinemaAddress!,
                              style: TextStyle(
                                color: booking.hasCinemaCoordinates
                                    ? context.color.territoryColor
                                    : Colors.black,
                                fontSize: 14,
                                height: 1.5,
                                decoration: booking.hasCinemaCoordinates
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                          if (booking.hasCinemaCoordinates) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.open_in_new,
                              size: 16,
                              color: context.color.territoryColor,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),

                // QR Note
                Row(
                  children: [
                    // Icon(
                    //   Icons.note_alt_outlined,
                    //   size: 24,
                    //   color: Colors.grey[800],
                    // ),
                    SvgPicture.asset(
                      AppIcons.note,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Xuất trình mã này tại quầy vé để nhận vé của bạn',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider with circles
          _buildDivider(),

          // Bottom Section - Barcode
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Barcode placeholder
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _buildBarcode(booking.code),
                  ),
                ),
                const SizedBox(height: 20),

                // Order ID
                Text(
                  'Order ID: ${booking.code}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      width: 125,
      height: 177,
      color: Colors.grey[300],
      child: const Icon(Icons.movie, color: Colors.grey, size: 50),
    );
  }

  Widget _buildBarcode(String code) {
    return BarcodeWidget(
      barcode: Barcode.code39(),
      data: code,
      width: double.infinity,
      height: 80,
      drawText: false,
      color: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dashed line
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: CustomPaint(
            painter: DashedLinePainter(),
            size: const Size(double.infinity, 1),
          ),
        ),

        // Left circle
        Positioned(
          left: -12,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Right circle
        Positioned(
          right: -12,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    const dashWidth = 5;
    const dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
