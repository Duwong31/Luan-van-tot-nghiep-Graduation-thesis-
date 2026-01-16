import 'package:Celes/data/cubits/booking/booking_cubit.dart';
import 'package:Celes/data/models/booking_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/app/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketHistoryScreen extends StatefulWidget {
  const TicketHistoryScreen({super.key});

  @override
  State<TicketHistoryScreen> createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUpcomingTickets(); // Load upcoming tickets by default
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _fetchUpcomingTickets() {
    context.read<BookingCubit>().fetchUserBookings(status: 'confirmed');
  }

  void _fetchHistoryTickets() {
    context.read<BookingCubit>().fetchUserBookings(status: 'completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.color.textColorDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          Tr.of(context)!.myTicket,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: context.color.textColorDark,
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.color.territoryColor,
          labelColor: context.color.textColorDark,
          unselectedLabelColor: context.color.textColorDark.withValues(alpha: 0.6),
          onTap: (index) {
            if (index == 0) {
              _fetchUpcomingTickets();
            } else {
              _fetchHistoryTickets();
            }
          },
          tabs: [
            Tab(text: Tr.of(context)!.upcomingTickets),
            Tab(text: Tr.of(context)!.historyTickets),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketTab(),
          _buildTicketTab(),
        ],
      ),
    );
  }

  Widget _buildTicketTab() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is MyBookingsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MyBookingsLoaded) {
          if (state.bookings.isEmpty) {
            return _buildEmptyState();
          }
          return _buildTicketList(state.bookings);
        } else if (state is MyBookingsError) {
          return _buildErrorState(state.errorMessage);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    // Determine message based on current tab
    String message = Tr.of(context)!.noTicketsFound;
    if (_tabController != null) {
      final currentIndex = _tabController!.index;
      if (currentIndex == 0) {
        message = Tr.of(context)!.noUpcomingTickets;
      } else {
        message = Tr.of(context)!.noTicketHistory;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 80,
            color: context.color.textColorDark.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          CustomText(
            message,
            fontSize: 18,
            color: context.color.textColorDark.withValues(alpha: 0.5),
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
            CustomText(
              message,
              fontSize: 16,
              color: context.color.textColorDark,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Retry based on current tab
                final currentIndex = _tabController?.index ?? 0;
                if (currentIndex == 0) {
                  _fetchUpcomingTickets();
                } else {
                  _fetchHistoryTickets();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.territoryColor,
              ),
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
        return _buildTicketItem(bookings[index]);
      },
    );
  }

  Widget _buildTicketItem(Booking booking) {
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
          color: context.color.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Movie Poster
                SizedBox(
                  width: 100,
                  height: 140,
                  child: booking.moviePoster != null
                      ? CachedNetworkImage(
                          imageUrl: booking.moviePoster!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie, size: 40),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.movie, size: 40),
                        ),
                ),

                // Movie Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          booking.movieTitle ?? 'Unknown Movie',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.color.textColorDark,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 14, color: context.color.territoryColor),
                            const SizedBox(width: 4),
                            CustomText(
                              '${booking.showtimeDate} at ${booking.showtimeTime}',
                              fontSize: 13,
                              color: context.color.textColorDark
                                  .withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: context.color.territoryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: CustomText(
                                booking.cinemaName ?? 'Cinema',
                                fontSize: 13,
                                color: context.color.textColorDark
                                    .withValues(alpha: 0.7),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.color.territoryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: context.color.territoryColor,
                                    width: 0.5),
                              ),
                              child: CustomText(
                                booking.code,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: context.color.territoryColor,
                              ),
                            ),
                            CustomText(
                              booking.formattedTotalPrice,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.color.territoryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
