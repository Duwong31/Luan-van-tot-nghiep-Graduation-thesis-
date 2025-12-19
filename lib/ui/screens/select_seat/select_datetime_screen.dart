import 'package:Celes/ui/screens/select_seat/select_seat_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectDateTimeScreen extends StatefulWidget {
  final String movieTitle;

  const SelectDateTimeScreen({
    super.key,
    required this.movieTitle,
  });

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();

  static Route route(RouteSettings routeSettings) {
    final movieTitle = routeSettings.arguments as String? ?? 'Movie';
    return MaterialPageRoute(
      builder: (_) => SelectDateTimeScreen(movieTitle: movieTitle),
    );
  }
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  int _selectedDateIndex = 2; // Default to "Today" (Wednesday)
  int _selectedCinemaIndex = -1;
  String? _selectedTime;

  // Generate dates for the week
  List<Map<String, dynamic>> _getDates() {
    final now = DateTime.now();
    return List.generate(6, (index) {
      final date =
          now.add(Duration(days: index - 2)); // Start from 2 days before
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return {
        'day': weekdays[date.weekday - 1],
        'date': date.day,
        'fullDate': date,
        'isToday': index == 2,
      };
    });
  }

  // Cinema data with showtimes
  List<Map<String, dynamic>> _getCinemas() {
    return [
      {
        'name': 'Vincom Ocean Park CGV',
        'address': 'Da Ton, Gia Lam, Ha Noi',
        'logoAsset': AppIcons.cgv,
        'showtimes': ['10:30', '12:15', '14:45', '16:00', '18:30', '20:45'],
      },
      {
        'name': 'Aeon Mall CGV',
        'address': '27 Co Linh, Long Bien, Ha Noi',
        'logoAsset': AppIcons.cgv,
        'showtimes': ['11:00', '13:30', '15:00', '17:15', '19:45', '21:30'],
      },
      {
        'name': 'Lotte Cinema Long Bien',
        'address': '14 Pho Ta Hien, Hoan Kiem, Ha Noi',
        'logoAsset': AppIcons.cgv,
        'showtimes': ['09:45', '11:30', '14:00', '16:15', '18:00', '20:30'],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dates = _getDates();
    final cinemas = _getCinemas();

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
        centerTitle: true,
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
          _buildDateSelector(dates),
          const SizedBox(height: 24),

          // Cinema list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cinemas.length,
              itemBuilder: (context, index) {
                return _buildCinemaCard(
                  context,
                  cinemas[index],
                  index,
                );
              },
            ),
          ),

          // Continue button
          _buildContinueButton(context),
        ],
      ),
    );
  }

  Widget _buildDateSelector(List<Map<String, dynamic>> dates) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(dates.length, (index) {
          final date = dates[index];
          final isSelected = _selectedDateIndex == index;
          final isToday = date['isToday'] as bool;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDateIndex = index;
                // Reset time selection when date changes
                _selectedTime = null;
                _selectedCinemaIndex = -1;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.color.territoryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        date['day'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : context.color.descriptionColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${date['date']}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : context.color.textDefaultColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // "Today" label outside card
                const SizedBox(height: 6),
                Text(
                  isToday ? 'Today' : '',
                  style: TextStyle(
                    color: context.color.territoryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCinemaCard(
    BuildContext context,
    Map<String, dynamic> cinema,
    int cinemaIndex,
  ) {
    final showtimes = cinema['showtimes'] as List<String>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.color.forthColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.color.forthColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cinema header
          Row(
            children: [
              // Cinema logo
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SvgPicture.asset(
                  cinema['logoAsset'] as String,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              // Cinema info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cinema['name'] as String,
                      style: TextStyle(
                        color: context.color.textDefaultColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cinema['address'] as String,
                      style: TextStyle(
                        color: context.color.descriptionColor,
                        fontSize: 13,
                      ),
                    ),
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
                final time = entry.value;
                final isSelected = _selectedCinemaIndex == cinemaIndex &&
                    _selectedTime == time;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index < showtimes.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCinemaIndex = cinemaIndex;
                        _selectedTime = time;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.color.territoryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? context.color.territoryColor
                              : context.color.descriptionColor
                                  .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : context.color.textDefaultColor,
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
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final isEnabled = _selectedTime != null && _selectedCinemaIndex != -1;
    final dates = _getDates();
    final cinemas = _getCinemas();

    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () {
                  final selectedCinema = cinemas[_selectedCinemaIndex];
                  final selectedDate =
                      dates[_selectedDateIndex]['fullDate'] as DateTime;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectSeatScreen(
                        cinemaName: selectedCinema['name'] as String,
                        showTime: _selectedTime!,
                        selectedDate: selectedDate,
                        roomNumber: _selectedCinemaIndex + 1,
                      ),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.color.territoryColor,
            disabledBackgroundColor:
                context.color.territoryColor.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            elevation: 0,
          ),
          child: Text(
            'Continue',
            style: TextStyle(
              color: isEnabled
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
