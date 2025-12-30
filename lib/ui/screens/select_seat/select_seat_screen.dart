import 'package:Celes/data/cubits/showtime/showtime_seats_cubit.dart';
import 'package:Celes/data/models/seat_model.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:Celes/ui/screens/select_seat/widgets/shadow_clipper.dart';

class SelectSeatScreen extends StatefulWidget {
  final String cinemaName;
  final String showTime;
  final String endTime;
  final DateTime selectedDate;
  final int roomNumber;
  final int showtimeId;

  const SelectSeatScreen({
    super.key,
    required this.cinemaName,
    required this.showTime,
    required this.endTime,
    required this.selectedDate,
    required this.showtimeId,
    this.roomNumber = 1,
  });

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();

  static Route route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;
    return MaterialPageRoute(
      builder: (_) => SelectSeatScreen(
        cinemaName: args?['cinemaName'] ?? 'Cinema',
        showTime: args?['showTime'] ?? '00:00',
        endTime: args?['endTime'] ?? '00:00',
        selectedDate: args?['selectedDate'] ?? DateTime.now(),
        roomNumber: args?['roomNumber'] ?? 1,
        showtimeId: args?['showtimeId'] ?? 0,
      ),
    );
  }
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  @override
  void initState() {
    super.initState();
    _fetchSeats();
  }

  void _fetchSeats() {
    context.read<ShowtimeSeatsCubit>().fetchShowtimeSeats(widget.showtimeId);
  }

  String _formatTime(String time) {
    // Remove seconds if present (HH:mm:ss -> HH:mm)
    return time.length > 5 ? time.substring(0, 5) : time;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final startTime = _formatTime(widget.showTime);
    final endTime = _formatTime(widget.endTime);
    final formattedDate = _formatDate(widget.selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xff000000),
      bottomNavigationBar: _buildBottomNavigationBar(),
      appBar: AppBar(
        backgroundColor: context.color.secondaryColor,
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.cinemaName,
              style: TextStyle(
                color: context.color.textDefaultColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Rạp ${widget.roomNumber}, $formattedDate, $startTime ~ $endTime',
              style: TextStyle(
                color: context.color.descriptionColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrow_left,
            height: 32,
            width: 32,
            colorFilter: ColorFilter.mode(
              context.color.textDefaultColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Screen section
          SizedBox(
            height: 80,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  top: 2,
                  child: ClipPath(
                    clipper: ScreenShadowClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xffFF1E00).withOpacity(0.21),
                            const Color(0xff000000)
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF1E00),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffFF1E00).withOpacity(0.25),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Seat grid container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Seat grid with zoom/pan support
                  Expanded(
                    child: BlocBuilder<ShowtimeSeatsCubit, ShowtimeSeatsState>(
                      builder: (context, state) {
                        if (state is ShowtimeSeatsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffFF1E00),
                            ),
                          );
                        }

                        if (state is ShowtimeSeatsError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: context.color.descriptionColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.errorMessage,
                                  style: TextStyle(
                                    color: context.color.descriptionColor,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchSeats,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFF1E00),
                                  ),
                                  child: const Text('Thử lại'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is ShowtimeSeatsEmpty) {
                          return Center(
                            child: Text(
                              state.message,
                              style: TextStyle(
                                color: context.color.descriptionColor,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }

                        if (state is ShowtimeSeatsLoaded) {
                          return InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 3.0,
                            boundaryMargin: const EdgeInsets.all(100),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: state.seatsByRow.map((seatRow) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: _buildSeatRow(
                                      context,
                                      seatRow,
                                      state.selectedSeatIds,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Legend
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Available', const Color(0xff1C1C1C)),
                _buildLegendItem('Reserved', const Color(0xFFF6F5FA)),
                _buildLegendItem('Selected', const Color(0xFFFF1E00)),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Color _getSeatColor(Seat seat, bool isSelected) {
    if (isSelected) {
      return const Color(0xffFF1E00);
    } else if (seat.isBooked || !seat.isAvailable) {
      return const Color(0xFFF6F5FA);
    } else {
      return const Color(0xff1C1C1C);
    }
  }

  Color _getSeatTextColor(Seat seat, bool isSelected) {
    if (isSelected) {
      return Colors.white;
    } else if (seat.isBooked || !seat.isAvailable) {
      return const Color(0xff000000);
    } else {
      return const Color(0xffAAAAAA);
    }
  }

  Widget _buildSeatRow(
    BuildContext context,
    SeatRow seatRow,
    Set<int> selectedSeatIds,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: seatRow.seats.map((seat) {
        final isSelected = selectedSeatIds.contains(seat.id);

        return GestureDetector(
          onTap: seat.isAvailable
              ? () {
                  context
                      .read<ShowtimeSeatsCubit>()
                      .toggleSeatSelection(seat.id);
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (MediaQuery.of(context).size.width - 80) / 15,
            height: (MediaQuery.of(context).size.width - 80) / 15,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: _getSeatColor(seat, isSelected),
              borderRadius: BorderRadius.circular(6),
              border: seat.isAvailable && !isSelected
                  ? Border.all(color: const Color(0xff555555), width: 1)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xffFF1E00).withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                seat.label,
                style: TextStyle(
                  color: _getSeatTextColor(seat, isSelected),
                  fontSize:
                      ((MediaQuery.of(context).size.width - 80) / 15) * 0.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xffF2F2F2),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BlocBuilder<ShowtimeSeatsCubit, ShowtimeSeatsState>(
      builder: (context, state) {
        int totalPrice = 0;
        int selectedCount = 0;
        bool hasSelection = false;

        if (state is ShowtimeSeatsLoaded) {
          totalPrice = state.totalPrice;
          selectedCount = state.selectedSeatIds.length;
          hasSelection = selectedCount > 0;
        }

        return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xff1C1C1C),
          ),
          child: Row(
            children: [
              // Total section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hasSelection ? 'Total ($selectedCount ghế)' : 'Total',
                      style: const TextStyle(
                        color: Color(0xffAAAAAA),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND',
                      style: const TextStyle(
                        color: Color(0xffFF1E00),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Buy ticket button
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: hasSelection
                        ? () {
                            // TODO: Navigate to payment screen
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF1E00),
                      disabledBackgroundColor:
                          const Color(0xffFF1E00).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Buy ticket',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
