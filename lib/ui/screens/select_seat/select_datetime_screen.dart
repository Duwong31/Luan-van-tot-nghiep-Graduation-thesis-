import 'package:Celes/data/cubits/movie/movie_showtimes_cubit.dart';
import 'package:Celes/data/models/showtime_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/screens/select_seat/select_seat_screen.dart';
import 'package:Celes/ui/screens/select_seat/widgets/date_selector.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

class SelectDateTimeScreen extends StatefulWidget {
  final String movieTitle;
  final int movieId;
  final String? movieImage;
  final String genres;

  const SelectDateTimeScreen({
    super.key,
    required this.movieTitle,
    required this.movieId,
    this.movieImage,
    required this.genres,
  });

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();

  static Route route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;
    final movieTitle = args?['movieTitle'] as String? ?? 'Movie';
    final movieId = args?['movieId'] as int? ?? 0;
    final movieImage = args?['movieImage'] as String?;
    final genres = args?['genres'] as String? ?? '';
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => MovieShowtimesCubit(),
        child: SelectDateTimeScreen(
          movieTitle: movieTitle,
          movieId: movieId,
          movieImage: movieImage,
          genres: genres,
        ),
      ),
    );
  }
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime? _selectedDate;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchShowtimes();
    _getCurrentLocation();
  }

  void _fetchShowtimes() {
    final date = _selectedDate ?? DateTime.now();
    context.read<MovieShowtimesCubit>().fetchShowtimesByDateTime(
          widget.movieId,
          date,
        );
  }

  /// Get current location of user
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    if (mounted) {
      setState(() {
        _currentPosition = position;
      });
    }
  }

  /// Calculate distance between user and cinema using HelperUtils
  String? _calculateDistance(double? cinemaLat, double? cinemaLng) {
    if (_currentPosition == null) {
      return null;
    }

    return HelperUtils.calculateDistance(
      userLat: _currentPosition!.latitude,
      userLng: _currentPosition!.longitude,
      targetLat: cinemaLat,
      targetLng: cinemaLng,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrow_left,
            height: 28,
            width: 28,
            colorFilter: ColorFilter.mode(
              context.color.textDefaultColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        title: Text(
          widget.movieTitle,
          style: TextStyle(
            color: context.color.textDefaultColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // Date selector
          const SizedBox(height: 16),
          DateSelector(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
              _fetchShowtimes();
            },
          ),
          const SizedBox(height: 24),

          // Showtimes list
          Expanded(
            child: BlocBuilder<MovieShowtimesCubit, MovieShowtimesState>(
              builder: (context, state) {
                if (state is MovieShowtimesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is MovieShowtimesError) {
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
                          onPressed: _fetchShowtimes,
                          child: Text(Tr.of(context)!.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is MovieShowtimesEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_filter_outlined,
                          size: 48,
                          color: context.color.descriptionColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: context.color.descriptionColor,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is MovieShowtimesLoaded) {
                  final showtimesByCinema =
                      state.showtimesData.showtimesByCinema;
                  final cinemaNames = showtimesByCinema.keys.toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cinemaNames.length,
                    itemBuilder: (context, index) {
                      final cinemaName = cinemaNames[index];
                      final showtimes = showtimesByCinema[cinemaName]!;
                      return _buildCinemaCard(
                        context,
                        cinemaName,
                        showtimes,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaCard(
    BuildContext context,
    String cinemaName,
    List<Showtime> showtimes,
  ) {
    // Get first showtime to extract cinema info
    final firstShowtime = showtimes.first;
    final cinemaAddress =
        firstShowtime.cinemaAddress ?? firstShowtime.cinemaLocation ?? '';
    
    // Calculate distance if coordinates available
    final distance = _calculateDistance(
      firstShowtime.cinemaLat,
      firstShowtime.cinemaLng,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cinema header
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 2,
                    height: 24,
                    color: context.color.territoryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Celes',
                    style: TextStyle(
                      color: context.color.territoryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Cinema info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cinemaName,
                            style: TextStyle(
                              color: context.color.textDefaultColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (distance != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: context.color.territoryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  distance,
                                  style: TextStyle(
                                    color: context.color.territoryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (cinemaAddress.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        cinemaAddress,
                        style: TextStyle(
                          color: context.color.descriptionColor,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Showtimes - horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: showtimes.asMap().entries.map((entry) {
                final index = entry.key;
                final showtime = entry.value;

                // Format time (remove seconds if present)
                final timeDisplay = showtime.startTime.length > 5
                    ? showtime.startTime.substring(0, 5)
                    : showtime.startTime;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index < showtimes.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: showtime.isAvailable
                        ? () {
                            final selectedDate =
                                _selectedDate ?? DateTime.now();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectSeatScreen(
                                  cinemaName: showtime.cinemaName,
                                  showTime: showtime.startTime,
                                  endTime: showtime.endTime,
                                  selectedDate: selectedDate,
                                  roomNumber: showtime.room?.id ?? 1,
                                  showtimeId: showtime.id,
                                  movieTitle: widget.movieTitle,
                                  movieImage: widget.movieImage,
                                  genres: widget.genres,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: showtime.isAvailable
                              ? context.color.descriptionColor
                                  .withValues(alpha: 0.3)
                              : context.color.descriptionColor
                                  .withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        timeDisplay,
                        style: TextStyle(
                          color: showtime.isAvailable
                              ? context.color.textDefaultColor
                              : context.color.descriptionColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Divider
          const SizedBox(height: 16),
          Divider(
            color: context.color.descriptionColor,
            height: 1,
          ),
        ],
      ),
    );
  }
}
